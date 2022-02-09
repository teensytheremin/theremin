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

    float yToPitch(int y) const;
    int pitchToY(float pitch) const;
    float minPitch() const { return _minpitch; }
    float maxPitch() const { return _maxpitch; }
    float pitchRange() const { return _maxpitch - _minpitch; }
    void setNoteRange(float minPitch, float maxPitch);
signals:
    void pitchRangeChanged(float minPitch, float maxPitch);
protected:
    void paintEvent(QPaintEvent *event) override;
    void wheelEvent(QWheelEvent * event) override;
    void mouseMoveEvent(QMouseEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;
private:
    float _minpitch;
    float _maxpitch;
    int _lastxpos;
};

#endif // PITCHEDITWIDGET_H
