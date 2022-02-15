#ifndef VOLUMEEDITWIDGET_H
#define VOLUMEEDITWIDGET_H

#include <QWidget>
#include "trackwidgetbase.h"

class VolumeEditWidget : public TrackWidgetBase
{
    Q_OBJECT
public:
    explicit VolumeEditWidget(PitchAndVolumeTrack * data, QWidget *parent = nullptr);

    QSize minimumSizeHint() const override;
    QSize sizeHint() const override;

signals:

protected:
    void paintEvent(QPaintEvent *event) override;
    void wheelEvent(QWheelEvent * event) override;

    float yToGain(int y) const;
    int gainToY(float pitch) const;
    /// minimum possible value
    float minValue() const override {
        return MIN_VOLUME_DB;
    }
    /// max possible value
    float maxValue() const  override {
        return MAX_VOLUME_DB;
    }
    /// value corresponding to top pixel of view
    float topValue() const override {
        return MAX_VOLUME_DB;
    }
    /// value corresponding to bottom pixel of view
    float bottomValue() const override {
        return MIN_VOLUME_DB;
    }
};

#endif // VOLUMEEDITWIDGET_H
