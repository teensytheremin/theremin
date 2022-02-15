#ifndef TRACKWIDGETBASE_H
#define TRACKWIDGETBASE_H

#include <QWidget>
#include "pitchandvolumetrack.h"

enum drawing_tool_t {
    DRAW_POINT,
    DRAW_LINE,
};

struct DrawingTool {
    drawing_tool_t toolType;
    float maxVelocity;
    float maxAcceleration;
};

class TrackWidgetBase : public QWidget
{
    Q_OBJECT
public:
    explicit TrackWidgetBase(TrackComponent component, PitchAndVolumeTrack * data, QWidget *parent = nullptr);

    int xLength() { return _xlength; }
    int xPosition() { return _xposition; }
    int xScale() { return _xscale; }
    float xScaleF() { return _xscalef; }
    void setXLength(int xlength);
    void setXPosition(int xposition);
    void setXScale(int xscale);
    void setXScaleF(float xscale);

    // x/index position conversion methods
    int posToX(int pos);
    int xToPos(int x);

    // y/value conversion methods
    /// minimum possible value
    virtual float minValue() const = 0;
    /// max possible value
    virtual float maxValue() const = 0;
    /// value corresponding to top pixel of view
    virtual float topValue() const = 0;
    /// value corresponding to bottom pixel of view
    virtual float bottomValue() const = 0;
    /// convert value to widget Y coordinate
    virtual int valueToY(float value) const;
    /// convert widget Y coordinate to value
    virtual float yToValue(int y) const;
    /// ensure value is within min/max limits
    float clampValue(float value) const {
        if (value > maxValue())
            return maxValue();
        else if (value < minValue())
            return minValue();
        return value;
    }
    /// returns difference between min and max values
    float valueRange() const {
        return maxValue() - minValue();
    }
    /// returns difference between top and bottom values
    float visibleValueRange() const {
        float range = topValue() - bottomValue();
        if (range < 0)
            return -range;
        return range;
    }
    float getValue(int index) const { return _data->getValue(_component, index); }
    void setValue(int index, float value) { _data->setValue(_component, index, value); }
    void setDrawingTool(DrawingTool * tool) {
        _drawingTool = tool;
    }
    DrawingTool * getDrawingTool() const {
        return _drawingTool;
    }
    float maxVelocity();
    float maxAcceleration();
signals:
    void xPositionChanged(int position);
    void xScaleChanged(float scale);
protected:
    TrackComponent _component;
    int _xlength;
    int _xposition;
    int _xscale;
    float _xscalef;
    PitchAndVolumeTrack * _data;
    DrawingTool * _drawingTool;
    int _lastxpos;
    IndexedFloats _points;
    bool _drawingToolActive;

    void wheelEvent(QWheelEvent * event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;

    int isHScrollEvent(QWheelEvent * event);
    int isHScaleEvent(QWheelEvent * event);
    int isVScrollEvent(QWheelEvent * event);
    int isVScaleEvent(QWheelEvent * event);

    // drawing
    void dimTail(QPainter & painter);
    void drawMeterMarks(QPainter & painter);
    void drawEditLines(QPainter & painter);
};

uint32_t blendARGB(uint32_t cl1, uint32_t cl2, uint32_t alpha);

#endif // TRACKWIDGETBASE_H
