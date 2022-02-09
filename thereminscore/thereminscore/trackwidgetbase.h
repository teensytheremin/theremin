#ifndef TRACKWIDGETBASE_H
#define TRACKWIDGETBASE_H

#include <QWidget>
#include "pitchandvolumetrack.h"

class TrackWidgetBase : public QWidget
{
    Q_OBJECT
public:
    explicit TrackWidgetBase(PitchAndVolumeTrack * data, QWidget *parent = nullptr);

    int xLength() { return _xlength; }
    int xPosition() { return _xposition; }
    int xScale() { return _xscale; }
    float xScaleF() { return _xscalef; }
    void setXLength(int xlength);
    void setXPosition(int xposition);
    void setXScale(int xscale);
    void setXScaleF(float xscale);

    int posToX(int pos);
    int xToPos(int x);
signals:
    void xPositionChanged(int position);
    void xScaleChanged(float scale);
protected:
    int _xlength;
    int _xposition;
    int _xscale;
    float _xscalef;
    PitchAndVolumeTrack * _data;

    void wheelEvent(QWheelEvent * event) override;
    void dimTail(QPainter & painter);
    void drawMeterMarks(QPainter & painter);
    int isHScrollEvent(QWheelEvent * event);
    int isHScaleEvent(QWheelEvent * event);
    int isVScrollEvent(QWheelEvent * event);
    int isVScaleEvent(QWheelEvent * event);
};

uint32_t blendARGB(uint32_t cl1, uint32_t cl2, uint32_t alpha);

#endif // TRACKWIDGETBASE_H
