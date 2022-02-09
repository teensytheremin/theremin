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
    void mouseMoveEvent(QMouseEvent *event) override;
    void mousePressEvent(QMouseEvent *event) override;
    void mouseReleaseEvent(QMouseEvent *event) override;

    float yToGain(int y) const;
    int gainToY(float pitch) const;

    int _lastxpos;
};

#endif // VOLUMEEDITWIDGET_H
