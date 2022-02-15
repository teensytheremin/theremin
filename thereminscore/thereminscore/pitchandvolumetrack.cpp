#include "pitchandvolumetrack.h"

#include <math.h>
#include <QDebug>

static float const MIN_COMPONENT_VALUES[2] = {
    MIN_NOTE,    // pitch
    MIN_VOLUME_DB, // volume
};

static float const MAX_COMPONENT_VALUES[2] = {
    MAX_NOTE, // pitch
    MAX_VOLUME_DB,  // volume
};

static float const DEF_COMPONENT_VALUES[2] = {
    69.0f, // pitch
    MIN_VOLUME_DB,  // volume
};

float clampComponent(TrackComponent component, float value) {
    if (value < MIN_COMPONENT_VALUES[component])
        return MIN_COMPONENT_VALUES[component];
    if (value > MAX_COMPONENT_VALUES[component])
        return MAX_COMPONENT_VALUES[component];
    return value;
}

// limit values to valid ones, if exceeded
void PitchAndVolume::clamp() {
    // ensure note is in midi note range 0..127
    note = clampNote(note);
    volume = clampVolume(volume);
}

// get component value by position
float PitchAndVolumeTrack::getValue(TrackComponent component, int xpos) const {
    if (!_len)
        return DEF_COMPONENT_VALUES[component];
    if (xpos < 0)
        return _data[0].value[component];
    if (xpos >= _len)
        return _data[_len-1].value[component];
    return clampComponent(component, _data[xpos].value[component]);
}

// set component value by position
void PitchAndVolumeTrack::setValue(TrackComponent component, int xpos, float value) {
    if (xpos < 0 || xpos >= _len)
        return;
    _data[xpos].value[component] = clampComponent(component, value);
}


PitchAndVolumeTrack::PitchAndVolumeTrack() : _data(nullptr), _size(0), _len(0), _framesPerSecond(SCORE_FRAME_RATE)
{

}

PitchAndVolumeTrack::~PitchAndVolumeTrack() {
    clear();
}

void PitchAndVolumeTrack::clear() {
    if (_data)
        delete[] _data;
    _data = nullptr;
    _len = 0;
    _size = 0;
}

PitchAndVolume defPitchAndVolumeItem;
const PitchAndVolume& PitchAndVolumeTrack::operator[] (int index) const {
    if (index < 0 || index >= _len)
        return defPitchAndVolumeItem;
    return _data[index];
}

PitchAndVolume rwdefPitchAndVolumeItem;
PitchAndVolume& PitchAndVolumeTrack::operator[] (int index) {
    if (index < 0)
        return rwdefPitchAndVolumeItem;
    if (index >= _len)
        setLength(index + 1);
    return _data[index];
}

PitchAndVolume PitchAndVolumeTrack::getInterpolated(double position) {
    PitchAndVolume a;
    PitchAndVolume b;
    if (_len < 2)
        return a;
    int baseIndex = (int)position;
    if (baseIndex > _len - 2)
        baseIndex = _len - 2;
    if (baseIndex < 0)
        baseIndex = 0;
    float delta = (float)(position - baseIndex);
    a = _data[baseIndex];
    b = _data[baseIndex + 1];
    // linear interpolation
    PitchAndVolume res;
    res.note = (1.0f - delta) * a.note + delta * b.note;
    res.volume = (1.0f - delta) * a.volume + delta * b.volume;
    res.clamp();
    return res;
}

float PitchAndVolumeTrack::posToSeconds(float pos) {
    return pos / _framesPerSecond;
}

float PitchAndVolumeTrack::secondsToPos(float seconds) {
    return seconds * _framesPerSecond;
}

void PitchAndVolumeTrack::truncate(int newLength) {
    if (newLength < _len && newLength >= 0) {
        setLength(newLength);
    }
}

void PitchAndVolumeTrack::setLength(int newLength) {
    if (newLength <= 0) {
        clear();
        return;
    }
    PitchAndVolume init;
    if (_len > 0) {
        init = _data[_len - 1];
    }
    if (newLength > _size) {
        int newSize = _size < 1200 ? 1200 : _size * 2;
        if (newSize < newLength) {
            newSize = newLength;
        }
        PitchAndVolume * p = new PitchAndVolume[newSize];
        if (_data) {
            // copy existing data
            for (int i = 0; i < _size; i++) {
                p[i] = _data[i];
            }
            delete[] _data;
        }
        _data = p;
        for (int i = _size; i < newSize; i++) {
            _data[i] = init;
        }
        _size = newSize;
    }
    // init with last sample
    for (int i = _len; i < newLength; i++) {
        _data[i] = init;
    }
    _len = newLength;
}

float PitchAndVolumeTrack::getAcceleration(TrackComponent component, int xpos) {
    if (xpos < 0 || xpos >= _len)
        return 0.0f;
    float vleft = 0.0f;
    if (xpos > 0)
        vleft = _data[xpos-1].value[component] - _data[xpos].value[component];
    float vright = 0.0f;
    if (xpos < _len - 1)
        vright = _data[xpos+1].value[component] - _data[xpos].value[component];
    float acc0 = (vleft + vright) / 2;
    return acc0;
}

void PitchAndVolumeTrack::smoothComponentLeft(TrackComponent component, int xpos, float value, float v0, float a0, float maxVelocity, float maxAcceleration) {
    PolyInterpolator solver;
    solver.init(MIN_COMPONENT_VALUES[component], MAX_COMPONENT_VALUES[component], maxVelocity, maxAcceleration);

    // fix left side
    solver.start(xpos, -1, value, value - v0, value - v0 - (v0 + a0));
    int leftFixDist = 0;
    for (int dist = 6; xpos - dist - 2 >= 0; dist++) {
        if (solver.end(xpos - dist, getValue(component, xpos - dist), getValue(component, xpos - dist - 1), getValue(component, xpos - dist - 2))) {
            leftFixDist = dist;
            break;
        }
    }
    if (leftFixDist) {
        for (int x = 1; x < leftFixDist; x++) {
            int xx = xpos - x;
            float y = solver.eval(xx);
            setValue(component, xx, y);
        }
    } else {
        // just smooth fill till end
        float v = v0;
        float y = value;
        for (int x = 1; xpos - x >= 0; x++) {
            y = y - v;
            setValue(component, xpos - x, y);
            v = v * 0.95f;
        }
    }
}

void PitchAndVolumeTrack::smoothComponentRight(TrackComponent component, int xpos, float value, float v0, float a0, float maxVelocity, float maxAcceleration) {
    PolyInterpolator solver;
    solver.init(MIN_COMPONENT_VALUES[component], MAX_COMPONENT_VALUES[component], maxVelocity, maxAcceleration);
    // fix right side
    solver.start(xpos, +1, value, value + v0 + a0, value + v0 + a0 + (v0 + a0));
    int rightFixDist = 0;
    for (int dist = 6; xpos + dist + 2 < _len; dist++) {
        if (solver.end(xpos + dist, getValue(component, xpos + dist), getValue(component, xpos + dist + 1), getValue(component, xpos + dist + 2))) {
            rightFixDist = dist;
            break;
        }
    }
    if (rightFixDist) {
        for (int x = 1; x < rightFixDist; x++) {
            int xx = xpos + x;
            float y = solver.eval(xx);
            setValue(component, xx, y);
        }
    } else {
        // just smooth fill till end
        float v = v0;
        float y = value;
        for (int x = 1; xpos + x < _len; x++) {
            y = y + v;
            setValue(component, xpos + x, y);
            v = v * 0.95f;
        }
    }
}

// set point value, limiting velocity and acceleration in region
void PitchAndVolumeTrack::setComponentValueLimited(TrackComponent component, int xpos, float value, float maxVelocity, float maxAcceleration) {
    if (xpos < 0)
        return;
    bool xoutside = false;
    float v0 = 0;
    float a0 = 0;
    float y0 = getValue(component, xpos);
    if (xpos >= _len) {
        setLength(xpos + 1);
        xoutside = true;
    }
    if (!xoutside) {
        float y01 = getValue(component, xpos - 1);
        float y02 = getValue(component, xpos + 1);
        float v01 = y0 - y01;
        float v02 = y02 - y0;
        v0 = (v01 + v02) / 2;
        a0 = (v02 - v01);
    }
    if (v0 > maxVelocity)
        v0 = maxVelocity;
    if (v0 < -maxVelocity)
        v0 = -maxVelocity;
    if (a0 > maxAcceleration)
        a0 = maxAcceleration;
    if (a0 < -maxAcceleration)
        a0 = -maxAcceleration;
    float ydist0 = value - y0;
    if (ydist0 < 0)
        ydist0 = -ydist0;
    float maxSnapDistance = 5.0f;
    if (ydist0 > maxSnapDistance) {
        // horizontal, no acceleration point if too far from existing value
        a0 = 0;
        v0 = 0;
    } else {
        // interpolate: velocity and acceleration : from unchanged near old point till zero at snap limit
        float k = 1.0f - ydist0 / maxSnapDistance;
        a0 = a0 * k;
        v0 = v0 * k;
    }

    setValue(component, xpos, value);

    smoothComponentLeft(component, xpos, value, v0, a0, maxVelocity, maxAcceleration);
    smoothComponentRight(component, xpos, value, v0, a0, maxVelocity, maxAcceleration);
}

void PitchAndVolumeTrack::fillInterpolated(TrackComponent component, IndexedFloats& dataPoints, float maxVelocity, float maxAcceleration) {
    int len = dataPoints.length();
    if (len < 1)
        return;
    if (len == 1) {
        setComponentValueLimited(component, dataPoints[0].index, dataPoints[0].value, maxVelocity, maxAcceleration);
        return;
    }
    // copy and sort left-to-right
    IndexedFloats points(dataPoints);
    if (points.last().index < points.first().index)
        points.reverse();
    // now start point is left, end is right
    IndexedFloat start = points.first();
    IndexedFloat end = points.last();

}

void PitchAndVolumeTrack::fillRegionInterpolated(TrackComponent component, int startx, float startValue, int endx, float endValue, float maxVelocity, float maxAcceleration) {
    if (startx < 0)
        startx = 0;
    if (endx < 0)
        endx = 0;
    if (startx >= _len)
        setLength(startx);
    if (endx >= _len)
        setLength(endx);
    int step = endx > startx ? 1 : -1;
    int dist = endx > startx ? (endx - startx) : (startx - endx);
    if (!dist) {
        setComponentValueLimited(component, endx, endValue, maxVelocity, maxAcceleration);
        return;
    }
    PolyInterpolator solver;
    solver.init(MIN_COMPONENT_VALUES[component], MAX_COMPONENT_VALUES[component], maxVelocity, maxAcceleration);

    int x0 = startx;
//    x0 -= step*2;
//    dist += 2;
//    while (dist < 7) {
//        x0 -= step;
//        dist++;
//    }
    for (int dx = 0; dx <= dist; dx++) {
        int x = x0 + dx*step;
        float y = startValue + dx * (endValue - startValue) * step / dist;
        //setValue(component, x, y);
        setComponentValueLimited(component, x, y, maxVelocity, maxAcceleration);
    }


//    float endv = (endValue - startValue) / (endx - startx);

//    for (int dx = 0; dx <= dist; dx++) {
//        int x = x0 + dx*step;
//        float y = startValue + dx * (endValue - startValue) / dist;
//        setValue(component, x, y);
//    }
//    if (step > 0) {
//        smoothComponentLeft(component, startx, startValue, endv, 0, maxVelocity, maxAcceleration);
//        smoothComponentRight(component, endx, endValue, endv, 0, maxVelocity, maxAcceleration);
//    } else {
//        smoothComponentLeft(component, endx, endValue, endv, 0, maxVelocity, maxAcceleration);
//        smoothComponentRight(component, startx, startValue, endv, 0, maxVelocity, maxAcceleration);
//    }

#if 0

    float y0 = getValue(component, x0);
    float y1 = getValue(component, x0 + step);
    float y2 = getValue(component, x0 + step * 2);

    int x2 = x0 + dist * step - 2;

    float y3 = y0 + (x2 - x0) * endv;
    float y4 = y0 + (x2 - x0 + 1) * endv;
    float y5 = y0 + (x2 - x0 + 2) * endv;

    // fix right side
    solver.start(x0, step, y0, y1, y2);
    if (solver.end(x2, y3, y4, y5)) {
        for (int dx = 0; dx <= dist; dx++) {
            int x = x0 + dx*step;
            float y = solver.eval(x);
            setValue(component, x, y);
        }
        if (step > 0) {
            smoothComponentRight(component, x0 + dist*step, endValue, endv, 0, maxVelocity, maxAcceleration);
        } else {
            smoothComponentLeft(component, x0 + dist*step, endValue, endv, 0, maxVelocity, maxAcceleration);
        }
    } else {
        // cannot find solution, draw line
        for (int dx = 0; dx <= dist; dx++) {
            int x = x0 + dx*step;
            float y = startValue + dx * (endValue - startValue) / dist;
            setValue(component, x, y);
        }
        // smooth a bit
        setComponentValueLimited(component, endx, endValue, maxVelocity, maxAcceleration);
    }
#endif
}

void PitchAndVolumeTrack::setPitchInterpolated(int startx, float startPitch, int endx, float endPitch) {
    if (startx < 0)
        startx = 0;
    if (endx < 0)
        endx = 0;
    if (startx >= _len)
        setLength(startx);
    if (endx >= _len)
        setLength(endx);
    int step = endx > startx ? 1 : -1;
    int dist = endx > startx ? (endx - startx) : (startx - endx);
    if (!dist) {
        _data[startx].note = endPitch;
        return;
    }
    for (int i = 0; i <= dist; i++) {
        int x = startx + i * step;
        float interpolated = startPitch + (endPitch - startPitch) * i / dist;
        _data[x].note = interpolated;
    }
}

void PitchAndVolumeTrack::setVolumeInterpolated(int startx, float startVolume, int endx, float endVolume) {
    if (startx < 0)
        startx = 0;
    if (endx < 0)
        endx = 0;
    if (startx >= _len)
        setLength(startx);
    if (endx >= _len)
        setLength(endx);
    int step = endx > startx ? 1 : -1;
    int dist = endx > startx ? (endx - startx) : (startx - endx);
    if (!dist) {
        _data[startx].volume = startVolume;
        return;
    }
    for (int i = 0; i <= dist; i++) {
        int x = startx + i * step;
        float interpolated = startVolume + (endVolume - startVolume) * i / dist;
        _data[x].volume = interpolated;
    }
}

void PolyInterpolator::init(float minvalue, float maxvalue, float maxVelocity, float maxAcceleration) {
    miny = minvalue;
    maxy = maxvalue;
    maxv = maxVelocity;
    maxa = maxAcceleration;
}

void PolyInterpolator::setPoints(IndexedFloat * points, int count) {
    x0 = (points[0].index + points[count-1].index) / 2;
    dir = points[0].index < points[count-1].index ? 1 : -1;
    for (int i = 0; i < count; i++) {
        x[i] = points[i].index - x0;
        y[i] = points[i].value;
    }
    size = count;
}

void PolyInterpolator::start(int x0, int dir, float y0, float y1, float y2) {
    this->x0 = x0;
    this->dir = dir;
    x[0] = 0;
    y[0] = y0;
    x[1] = 1*dir;
    y[1] = y1;
    x[2] = 2*dir;
    y[2] = y2;
}


bool PolyInterpolator::solve() {
    double m[MAX_POLY_POINTS][MAX_POLY_POINTS];
    double n[MAX_POLY_POINTS];
    // prepare matrix
    for (int row = 0; row < size; row++) {
        double xpow = 1.0;
        for (int col = size-1; col >= 0; col--) {
            m[size-1-row][col] = xpow;
            xpow *= x[row];
        }
        n[size-1-row] = y[row];
    }
    if (!solveLinSystem(m, n, a, 6))
        return false;
    return true;
}

bool PolyInterpolator::end(int xx, float y0, float y1, float y2) {
    size = 6;
    x[3] = xx-x0;
    y[3] = y0;
    x[4] = xx-x0 + dir*1;
    y[4] = y1;
    x[5] = xx-x0 + dir*2;
    y[5] = y2;

    return solveAndCheckLimits();
}

bool PolyInterpolator::checkLimits() {
    // find X range
    int minx = x[0];
    int maxx = x[0];
    for (int i = 1; i < size; i++) {
        if (minx > x[i])
            minx = x[i];
        if (maxx < x[i])
            maxx = x[i];
    }
    for (int xxx = minx; xxx <= maxx; xxx++) {
        float value = eval(xxx + x0);
        if (value > maxy || value < miny) {
            //qDebug("y at %d : %f exceeded range (%f, %f)", xxx, value, miny, maxy);
            return false;
        }
        float vel = velocityAt(xxx);
        if (vel > maxv || vel < -maxv) {
            //qDebug("velocity at %d : %f exceeded %f", xxx, vel, maxv);
            return false;
        }
        float acc = accelerationAt(xxx);
        if (acc > maxa || acc < -maxa) {
            //qDebug("acceleration at %d : %f exceeded %f", xxx, acc, maxa);
            return false;
        }
    }
    return true;
}

bool PolyInterpolator::solveAndCheckLimits() {
    if (!solve())
        return false;
    return checkLimits();
}

float PolyInterpolator::eval(int xx) {
    double xxx = xx - x0;
    double xpow = 1.0;
    double res = 0.0;
    for (int col = size - 1; col >= 0; col--) {
        res += xpow * a[col];
        xpow *= xxx;
    }
    return static_cast<float>(res);
}

float PolyInterpolator::velocityAt(int x) {
    // d(x^b)/dx =  b x ^ (b-1)
    double a2[MAX_POLY_POINTS];
    int p = 1;
    for (int i = size - 2; i >= 0; i--) {
        a2[i] = a[i] * p;
        p++;
    }
//    a2[5] = a[5] * 0; // a[5]
//    a2[4] = a[4] * 1; // a[4] * x
//    a2[3] = a[3] * 2; // a[3] * x^2
//    a2[2] = a[2] * 3; // a[2] * x^3
//    a2[1] = a[1] * 4; // a[1] * x^4
//    a2[0] = a[0] * 5; // a[0] * x^5
    double xpow = 1.0;
    double res = 0.0;
    for (int col = size-2; col >= 0; col--) {
        res += xpow * a2[col];
        xpow *= x;
    }
    return static_cast<float>(res);
}

float PolyInterpolator::accelerationAt(int x) {
    // d(x^b)/dx =  b x ^ (b-1)
    // d2(x^b)/dx =  b (b-1) x ^ (b-2)
    double a3[MAX_POLY_POINTS];
    int p = 1;
    for (int i = size - 3; i >= 0; i--) {
        a3[i] = a[i] * p * (p + 1);
        p++;
    }
//    a3[5] = a[5] * 0; // a[5]
//    a3[4] = a[4] * 0; // a[4] * x
//    a3[3] = a[3] * 2 * 1; // a[3] * x^2
//    a3[2] = a[2] * 3 * 2; // a[2] * x^3
//    a3[1] = a[1] * 4 * 3; // a[1] * x^4
//    a3[0] = a[0] * 5 * 4; // a[0] * x^5
    double xpow = 1.0;
    double res = 0.0;
    for (int col = size - 3; col >= 0; col--) {
        res += xpow * a3[col];
        xpow *= x;
    }
    return static_cast<float>(res);
}


//void dumpM(double m[6][6], double n[6]) {
//    for (int row = 0; row < 6; row++) {
//        qDebug("%f\t%f\t%f\t%f\t%f\t%f\t\t%f", m[row][5], m[row][4], m[row][3], m[row][2], m[row][1], m[row][0], n[row]);
//    }
//}

bool solveLinSystem(double m[MAX_POLY_POINTS][MAX_POLY_POINTS], double n[MAX_POLY_POINTS], double result[MAX_POLY_POINTS], int size) {
    //qDebug("Before");
    //dumpM(m,n);
    // forward pass
    for (int i = 0; i < size; i++) {
        // 1) make m[i][i] == 1 : divide all items in row by m[i][i]
        double divider = m[i][i];
        if (divider > -1e-6 && divider < 1e-6) {
            // TODO: try reordering rows
            return false;
        }
        for (int j = i + 1; j < size; j++) {
            m[i][j] = m[i][j] / divider;
        }
        n[i] = n[i] / divider;
        m[i][i] = 1.0f;
        // 2) subtract row[i] from all rows below
        for (int k = i + 1; k < size; k++) {
            double mul = m[k][i];
            m[k][i] = 0.0f;
            for (int j = i + 1; j < size; j++) {
                m[k][j] -= m[i][j] * mul;
            }
            n[k] -= n[i] * mul;
        }
    }
//    qDebug("After forward pass");
//    dumpM(m,n);
    // now diagonal is 1.0f, left half is 0.0f
    // backward pass
    for (int i = size - 1; i >= 0; i--) {
        // subtract row[i] from all rows above
        for (int k = i - 1; k >= 0; k--) {
            double mul = m[k][i];
            m[k][i] = 0.0f;
            n[k] -= n[i] * mul;
        }
    }
//    qDebug("After backward pass");
//    dumpM(m,n);
    for (int i = 0; i < size; i++) {
        result[i] = n[i];
    }
    return true;
}


