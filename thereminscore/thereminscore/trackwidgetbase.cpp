#include "trackwidgetbase.h"
#include <QWheelEvent>
#include <QPainter>

uint32_t blendARGB(uint32_t cl1, uint32_t cl2, uint32_t alpha) {
    if (alpha == 0)
        return cl1;
    else if (alpha == 255)
        return cl2;
    uint32_t a1 = (cl1 >> 24) & 0xff;
    uint32_t r1 = (cl1 >> 16) & 0xff;
    uint32_t g1 = (cl1 >> 8) & 0xff;
    uint32_t b1 = (cl1 >> 0) & 0xff;
    uint32_t a2 = (cl2 >> 24) & 0xff;
    uint32_t r2 = (cl2 >> 16) & 0xff;
    uint32_t g2 = (cl2 >> 8) & 0xff;
    uint32_t b2 = (cl2 >> 0) & 0xff;
    uint32_t a = (a1 * (255-alpha) + a2 * alpha) >> 8;
    uint32_t r = (r1 * (255-alpha) + r2 * alpha) >> 8;
    uint32_t g = (g1 * (255-alpha) + g2 * alpha) >> 8;
    uint32_t b = (b1 * (255-alpha) + b2 * alpha) >> 8;
    return (a << 24) | (r << 16) | (g << 8) | (b << 0);
}


TrackWidgetBase::TrackWidgetBase(TrackComponent component, PitchAndVolumeTrack * data, QWidget *parent) : QWidget(parent), _component(component), _xlength(1000), _xposition(0), _xscale(2), _data(data), _drawingTool(nullptr)
{
    _lastxpos = 0;
    _drawingToolActive = false;
}

void TrackWidgetBase::setXLength(int xlength) {
    if (xlength == _xlength)
        return;
    _xlength = xlength;
    update();
}

void TrackWidgetBase::setXPosition(int xposition) {
    if (xposition == _xposition)
        return;
    _xposition = xposition;
    update();
}

void TrackWidgetBase::setXScale(int xscale) {
    if (xscale == _xscale)
        return;
    if (xscale < 1)
        xscale = 1;
    _xscale = xscale;
    _xscalef = xscale;
    update();
}

void TrackWidgetBase::setXScaleF(float xscale) {
    if (xscale == _xscalef)
        return;
    if (xscale < 1.0f)
        xscale = 1.0f;
    _xscalef = xscale;
    _xscale = (int)(_xscalef + 0.5f);
    update();
}

int TrackWidgetBase::posToX(int pos) {
    return (pos - _xposition) / _xscale;
}

int TrackWidgetBase::xToPos(int x) {
    return x * _xscale + _xposition;
}

void TrackWidgetBase::mousePressEvent(QMouseEvent *event) {
    int x = event->pos().x();
    int y = event->pos().y();
    int xpos = xToPos(x);
    float value = yToValue(y);
    if (event->button() == Qt::MouseButton::LeftButton) {
        _data->setComponentValueLimited(TRACK_PITCH, xpos, value, maxVelocity(), maxAcceleration());
        //_data->setPitchVelocityLimited(xpos, pitch, MAX_PITCH_VELOCITY);
        _points.clear();
        _points.append(IndexedFloat(xpos, value));
        _drawingToolActive = true;
        _lastxpos = xpos;
        event->accept();
        update();
    }
}


void limitLastPoint(IndexedFloats & points, float maxVelocity) {
    int len = points.length();
    if (len < 2)
        return;
    IndexedFloat p1 = points[len - 2];
    IndexedFloat p2 = points[len - 1];
    int dist = p2.index - p1.index;
    if (dist < 0)
        dist = -dist;
    float minlimit = p1.value - maxVelocity * dist;
    float maxlimit = p1.value + maxVelocity * dist;
    if (p2.value > maxlimit) {
        p2.value = maxlimit;
        points.set(len-1, p2);
    } else if (p2.value < minlimit) {
        p2.value = minlimit;
        points.set(len-1, p2);
    }
}

void TrackWidgetBase::mouseMoveEvent(QMouseEvent *event) {
    int x = event->pos().x();
    int y = event->pos().y();
    int xpos = xToPos(x);
    float value = clampValue(yToValue(y));
    if (event->buttons() & Qt::MouseButton::LeftButton) {
        if (!_points.length())
            return;
        int startpos = _points[0].index;
        int dist = xpos - startpos;
        if (!dist)
            return;
        while (_points.length() > 1) {
            int lastpos = _points.last().index;
            int lastdist = lastpos - startpos;
            if (dist > 0 && dist > lastdist)
                break;
            if (dist < 0 && dist < lastdist)
                break;
            // remove last
            _points.removeLast();
        }
        _points.append(IndexedFloat(xpos, value));
        limitLastPoint(_points, maxVelocity());
        //_data->setPitchVelocityLimited(xpos, pitch, MAX_PITCH_VELOCITY);
        event->accept();
        update();
    }
}


void TrackWidgetBase::mouseReleaseEvent(QMouseEvent *event) {
    // TODO:
    if (_drawingToolActive) {
        _data->fillInterpolated(_component, _points, maxVelocity(), maxAcceleration());
        _drawingToolActive = false;
    }
    update();
}

void TrackWidgetBase::wheelEvent(QWheelEvent * event) {
    int x = event->position().toPoint().x();
    int y = event->position().toPoint().y();
    Qt::MouseButtons mouseFlags = event->buttons();
    Qt::KeyboardModifiers keyFlags = event->modifiers();
    QPoint angleDelta = event->angleDelta();
    Qt::ScrollPhase phase = event->phase();
    qDebug("wheelEvent(x=%d, y=%d, mouse=%x, keymodifiers=%x delta=(%d %d) phase=%d)", x, y, mouseFlags, keyFlags, angleDelta.x(), angleDelta.y(), phase);
    int hScrollDelta = isHScrollEvent(event);
    if (hScrollDelta) {
        // horizontal scroll
        int xdelta = - hScrollDelta * _xscale;
        int newx = _xposition + xdelta;
        if (newx < 0)
            newx = 0;
        else if (newx > _xlength)
            newx = _xlength;
        qDebug("HScroll xdelta=%d %d -> %d", xdelta, _xposition, newx);
        if (newx != _xposition) {
            setXPosition(newx);
            emit xPositionChanged(newx);
        }
        event->accept();
        return;
    }
    int hscaleDelta = isHScaleEvent(event);
    if (hscaleDelta) {
        // horizontal zoom
        int xdelta = - hscaleDelta * _xscale;
        float scaleBase = 256.0f;
        float newScale = (xdelta > 0)
                ? (_xscalef * (scaleBase + xdelta) / scaleBase)
                : (_xscalef * scaleBase / (scaleBase - xdelta));
        if (_xlength / newScale < width() / 4)
            newScale = _xlength / (width() / 4);
        if (newScale < 1.0f)
            newScale = 1.0f;
        int newIScale = (int)(newScale + 0.5f);
        //int x = event->pos().x();
        int oldpos = _xposition + x * _xscale;
        int newpos = _xposition + x * newIScale;
        int posCorrection = oldpos - newpos;

        qDebug("X Zoom: old scale %f new scale %f pos correction %d", _xscalef, newScale, posCorrection);
        if (_xscalef != newScale) {
            setXScaleF(newScale);
            emit xScaleChanged(_xscalef);
            if (posCorrection != 0) {
                int correctedPosition = _xposition + posCorrection;
                setXPosition(correctedPosition);
                emit xPositionChanged(correctedPosition);
            }
        }
        event->accept();
        return;
    }
}


void TrackWidgetBase::dimTail(QPainter & painter) {
    int w = width();
    int h = height();
    int lastdatax = posToX(_xlength);
    if (lastdatax >=0 && lastdatax < w) {
        painter.fillRect(QRect(lastdatax, 0, w, h), QBrush(QColor(0,0,0,96)));
    }
}

void TrackWidgetBase::drawMeterMarks(QPainter & painter) {
    float time = _data->meter().startOffsetSeconds;
    int secondaryTicks = _data->meter().secondaryTicksCount;
    float increment = _data->meter().mainTicksSeconds / secondaryTicks;
    int tickIndex = 0;
    int maxpos = _xposition + width() * _xscale;

    int h = height();

    QBrush mainTickBrush(QColor(255,255,192,96));
    QBrush secondaryTickBrush(QColor(160,160,140,64));

    for (;;) {
        int pos = (int)(_data->secondsToPos(time) + 0.5f);
        if (pos > maxpos)
            break;
        if (pos >= _xposition) {
            int x = posToX(pos);
            painter.fillRect(QRect(x, 0, 1, h), (tickIndex == 0) ? mainTickBrush : secondaryTickBrush);
        }
        time += increment;
        tickIndex++;
        if (tickIndex >= secondaryTicks)
            tickIndex = 0;
    }
}

int TrackWidgetBase::isHScrollEvent(QWheelEvent * event) {
    QPoint angleDelta = event->angleDelta();
    Qt::MouseButtons mouseFlags = event->buttons();
    Qt::KeyboardModifiers keyFlags = event->modifiers();
    // touch pad hscroll gesture
    if (angleDelta.y() == 0 && angleDelta.x() != 0 && mouseFlags == 0 && keyFlags == 0) {
        return angleDelta.x();
    }
    // mouse Shift + wheel
    if (angleDelta.x() == 0 && angleDelta.y() != 0 && mouseFlags == 0 && (keyFlags & Qt::ControlModifier) ==  0
            && (keyFlags & Qt::ShiftModifier) !=  0) {
        return angleDelta.y();
    }
    return 0;
}

int TrackWidgetBase::isHScaleEvent(QWheelEvent * event) {
    QPoint angleDelta = event->angleDelta();
    Qt::MouseButtons mouseFlags = event->buttons();
    Qt::KeyboardModifiers keyFlags = event->modifiers();
    // touch pad hscroll + Ctrl
    if (angleDelta.y() == 0 && angleDelta.x() != 0 && mouseFlags == 0 && (keyFlags & Qt::ControlModifier) !=  0
            && (keyFlags & Qt::ShiftModifier) ==  0) {
        return angleDelta.x();
    }
    // mouse or touch pad vscroll + Shift + Ctrl
    if (angleDelta.y() != 0 && angleDelta.x() == 0 && mouseFlags == 0 && (keyFlags & Qt::ControlModifier) !=  0
             && (keyFlags & Qt::ShiftModifier) !=  0) {
        return angleDelta.y();
    }
    return 0;
}

int TrackWidgetBase::isVScrollEvent(QWheelEvent * event) {
    QPoint angleDelta = event->angleDelta();
    Qt::MouseButtons mouseFlags = event->buttons();
    Qt::KeyboardModifiers keyFlags = event->modifiers();
    if (angleDelta.y() != 0 && angleDelta.x() == 0 && mouseFlags == 0 && keyFlags == 0) {
        return angleDelta.y();
    }
    return 0;
}


int TrackWidgetBase::isVScaleEvent(QWheelEvent * event) {
    QPoint angleDelta = event->angleDelta();
    Qt::MouseButtons mouseFlags = event->buttons();
    Qt::KeyboardModifiers keyFlags = event->modifiers();
    // mouse wheel or touch pad vscroll + Ctrl
    if (angleDelta.x() == 0 && angleDelta.y() != 0 && mouseFlags == 0 && (keyFlags & Qt::ControlModifier) !=  0
            && (keyFlags & Qt::ShiftModifier) ==  0) {
        return angleDelta.y();
    }
    return 0;
}

/// convert value to widget Y coordinate
int TrackWidgetBase::valueToY(float value) const {
    float top = topValue();
    float bottom = bottomValue();
    return static_cast<int>(height() * (value - top) / (bottom - top));
}

/// convert widget Y coordinate to value
float TrackWidgetBase::yToValue(int y) const {
    float top = topValue();
    float bottom = bottomValue();
    if (height() <= 0)
        return bottom;
    return top + y * (bottom - top) / height();
}

float TrackWidgetBase::maxVelocity() {
    return valueRange() * _drawingTool->maxVelocity;
}

float TrackWidgetBase::maxAcceleration() {
    return valueRange() * _drawingTool->maxAcceleration;
}

void TrackWidgetBase::drawEditLines(QPainter & painter) {
    if (!_drawingToolActive || _points.length() < 2)
        return;

    int penWidth = 2;
    Qt::PenStyle style = Qt::PenStyle(Qt::SolidLine);
    Qt::PenCapStyle cap = Qt::PenCapStyle(Qt::RoundCap);
    Qt::PenJoinStyle join = Qt::PenJoinStyle(Qt::RoundJoin);
    QPen pen(QColor(255, 128, 128), penWidth, style, cap, join);
    painter.setPen(pen);

    //
    QVector<QPointF> points;
    float lastX = -1;
    float lastY = -1;
    for (int i = 0; i < _points.length(); i++) {
        IndexedFloat data = _points[i];
        int pointX = posToX(data.index);
        int pointY = valueToY(data.value);
        float deltax = abs(pointX - lastX);
        float deltay = abs(pointY - lastY);
        if (deltax > 0.5f || deltay > 0.5f) {
            points.append(QPointF(pointX, pointY));
            lastX = pointX;
            lastY = pointY;
        }
    }
    painter.drawPolyline(points);
}
