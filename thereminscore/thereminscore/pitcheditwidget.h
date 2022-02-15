#ifndef PITCHEDITWIDGET_H
#define PITCHEDITWIDGET_H

#include <QWidget>
#include "trackwidgetbase.h"

class PitchEditWidget : public TrackWidgetBase
{
    Q_OBJECT


public:
    explicit PitchEditWidget(PitchAndVolumeTrack * data, QWidget *parent = nullptr);

    QSize minimumSizeHint() const override;
    QSize sizeHint() const override;

//    float yToPitch(int y) const { return yToValue(y); }
//    int pitchToY(float pitch) const { return valueToY(pitch); }
//    float minPitch() const { return _minpitch; }
//    float maxPitch() const { return _maxpitch; }
    //float pitchRange() const { return _maxpitch - _minpitch; }
    void setNoteRange(float minPitch, float maxPitch);

    /// minimum possible value
    float minValue() const override {
        return MIN_NOTE;
    }
    /// max possible value
    float maxValue() const  override {
        return MAX_NOTE;
    }
    /// value corresponding to top pixel of view
    float topValue() const override {
        return _maxpitch;
    }
    /// value corresponding to bottom pixel of view
    float bottomValue() const override {
        return _minpitch;
    }
signals:
    void pitchRangeChanged(float minPitch, float maxPitch);
protected:
    void paintEvent(QPaintEvent *event) override;
    void wheelEvent(QWheelEvent * event) override;
private:
    float _minpitch;
    float _maxpitch;
};

#endif // PITCHEDITWIDGET_H
