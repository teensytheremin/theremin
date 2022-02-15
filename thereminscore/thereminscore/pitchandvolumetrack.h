#ifndef PITCHANDVOLUMETRACK_H
#define PITCHANDVOLUMETRACK_H

#include "noteutil.h"

// sample rate samples per second
#define SCORE_SAMPLE_RATE 48000

/*

    Frame rate selection.

    Based on sample rate.
    Divisible by 50 and 60.

    lcm(50,60) = 300

    300,600,900,1200

    48000/1200 = 40
    48000/600 = 80

*/

// score frame rate, frames per second
#define SCORE_FRAME_RATE 1200
// score frame size, samples (40 for 48KHz / 1200 fps)
#define SCORE_FRAME_SIZE (SCORE_SAMPLE_RATE/SCORE_FRAME_RATE)


struct TrackMeter {
    float startOffsetSeconds;
    float mainTicksSeconds;
    int secondaryTicksCount;
    TrackMeter() : startOffsetSeconds(0.0f), mainTicksSeconds(2.0f), secondaryTicksCount(4) { }
};

#define TRACK_COMPONENTS_COUNT 2
enum TrackComponent {
    TRACK_PITCH,
    TRACK_VOLUME
};

float clampComponent(TrackComponent component, float value);

struct PitchAndVolume {
    union {
        struct {
            float note;
            float volume;
        };
        float value[2];
    };
    PitchAndVolume() : note(69.0f), volume(-100.0f) {}
    PitchAndVolume(float p, float v) : note(p), volume(v) {}
    PitchAndVolume(const PitchAndVolume& v) : note(v.note), volume(v.volume) {}
    void operator = (const PitchAndVolume& v) {
        note = v.note;
        volume = v.volume;
    }
    // limit values to valid ones, if exceeded
    void clamp();
};

template<typename T>
class DynamicArray
{
protected:
    T * _data;
    int _size;
    int _len;
public:
    int size() const { return _size; }
    int length() const { return _len; }
    T* ptr(int startIndex = 0) {
        return _data + startIndex;
    }
    void setLength(int newLength) {
        if (newLength <= 0) {
            clear();
            return;
        }
        T init;
        if (_len > 0) {
            init = _data[_len - 1];
        }
        if (newLength > _size) {
            int newSize = _size < 1200 ? 1200 : _size * 2;
            if (newSize < newLength) {
                newSize = newLength;
            }
            T * p = new T[newSize];
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
    void truncate(int newLength) {
        if (newLength < _len && newLength >= 0) {
            setLength(newLength);
        }
    }
    void clear() {
        if (_data)
            delete[] _data;
        _data = nullptr;
        _len = 0;
        _size = 0;
    }
    void reverse() {
        for (int i = 0; i < _len/2; i++) {
            T tmp = _data[_len - i - 1];
            _data[_len - i - 1] = _data[i];
            _data[i] = tmp;
        }
    }
    DynamicArray() : _data(nullptr), _size(0), _len(0) {}
    DynamicArray(const DynamicArray& v) : _data(nullptr) {
        _size = v._len;
        _len = v._len;
        if (_len) {
            _data = new T[_size];
            for (int i = 0; i < _len; i++)
                _data[i] = v._data[i];
        }
    }
    ~DynamicArray() { clear(); }
    T operator [] (int index) const { return get(index); }
    T get(int index) const {
        if (_len <= 0)
            return T();
        if (index < 0)
            return _data[0];
        else if (index >= _len)
            return _data[_len - 1];
        else
            return _data[index];
    }
    void set(int index, T value) {
        if (index >= 0 && index < _len)
            _data[index] = value;
    }
    void append(T value) {
        setLength(_len + 1);
        _data[_len - 1] = value;
    }
    T last() const {
        if (_len > 0)
            return _data[_len - 1];
        return T();
    }
    T first() const {
        if (_len > 0)
            return _data[0];
        return T();
    }
    T removeLast() {
        T res = last();
        if (_len > 0)
            setLength(_len - 1);
        return res;
    }
};

struct IndexedFloat {
    int index;
    float value;
    IndexedFloat() : index(0), value(0) {}
    IndexedFloat(int idx, float v) : index(idx), value(v) {}
    IndexedFloat(const IndexedFloat &v) : index(v.index), value(v.value) {}
};

typedef DynamicArray<IndexedFloat> IndexedFloats;

class PitchAndVolumeTrack
{
protected:
    PitchAndVolume * _data;
    int _size;
    int _len;

    int _framesPerSecond;
    TrackMeter _meter;

public:
    int size() const { return _size; }
    int length() const { return _len; }
    void setLength(int newLength);
    void truncate(int newLength);
    void clear();
    float posToSeconds(float pos);
    float secondsToPos(float seconds);
    int framesPerSecond() { return _framesPerSecond; }
    void setFramesPerSecond(float frames) { _framesPerSecond = frames; }
    TrackMeter & meter() { return _meter; }
    PitchAndVolume getInterpolated(double position);
    PitchAndVolumeTrack();
    ~PitchAndVolumeTrack();
    const PitchAndVolume& operator [] (int index) const;
    const PitchAndVolume& get(int index) const { return (*this)[index]; }

    // get component value by position (returns closest value if out of range)
    float getValue(TrackComponent component, int xpos) const;
    // set component value by position (does nothing if out of range)
    void setValue(TrackComponent component, int xpos, float value);

    PitchAndVolume& operator [] (int index);
    void setPitchInterpolated(int startx, float startPitch, int endx, float endPitch);
    void setVolumeInterpolated(int startx, float startVolume, int endx, float endVolume);
    void fillRegionInterpolated(TrackComponent component, int startx, float startValue, int endx, float endValue, float maxVelocity, float maxAcceleration);
    void fillInterpolated(TrackComponent component, IndexedFloats& points, float maxVelocity, float maxAcceleration);

    // returns velocity of component (value[xpos+direction] - value[xpos]) where direction is either -1 or +1
    float getVelocity(TrackComponent component, int xpos, int direction) {
        if (xpos < 0 || xpos >=_len || xpos+direction < 0 || xpos+direction >= _len)
            return 0.0f; // position outside data range, return 0.0f as velocity outside range
        return _data[xpos + direction].value[component] - _data[xpos].value[component];
    }

    // set point value, limiting velocity and acceleration in region
    void setComponentValueLimited(TrackComponent component, int xpos, float value, float maxVelocity, float maxAcceleration);

    void smoothComponentLeft(TrackComponent component, int xpos, float y0, float v0, float a0, float maxVelocity, float maxAcceleration);
    void smoothComponentRight(TrackComponent component, int xpos, float y0, float v0, float a0, float maxVelocity, float maxAcceleration);

    float getAcceleration(TrackComponent component, int xpos);
    float getVolumeAcceleration(int xpos) { return getAcceleration(TRACK_VOLUME, xpos); }
    float getPitchAcceleration(int xpos) { return getAcceleration(TRACK_PITCH, xpos); }
};

#define MAX_POLY_POINTS 6
struct PolyInterpolator {
    // min value limit
    float miny;
    // max value limit
    float maxy;
    // velocity limit
    float maxv;
    // acceleration limit
    float maxa;
    // points
    float y[MAX_POLY_POINTS];
    int x[MAX_POLY_POINTS];
    // calculated polynome coefficients
    double a[MAX_POLY_POINTS];
    // starting X
    int x0;
    // direction
    int dir;
    // number of points
    int size;
    PolyInterpolator() : size(6) {}
    void init(float minvalue, float maxvalue, float maxVelocity, float maxAcceleration);
    void setPoints(IndexedFloat * points, int count);
    void setPoints(IndexedFloats& points) { setPoints(points.ptr(), points.length()); }
    void setPoints(IndexedFloats& points, int startIndex, int count) { setPoints(points.ptr(startIndex), count); }
    void start(int x0, int dir, float y0, float y1, float y2);
    bool end(int x0, float y0, float y1, float y2);
    bool solve();
    bool checkLimits();
    bool solveAndCheckLimits();

    float eval(int xx);
    float velocityAt(int x);
    float accelerationAt(int x);
};

bool solveLinSystem(double m[MAX_POLY_POINTS][MAX_POLY_POINTS], double n[MAX_POLY_POINTS], double result[MAX_POLY_POINTS], int size);


#endif // PITCHANDVOLUMETRACK_H
