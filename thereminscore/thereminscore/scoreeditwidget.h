#ifndef SCOREEDITWIDGET_H
#define SCOREEDITWIDGET_H

#include <QWidget>
#include "pitchandvolumetrack.h"
#include "pitcheditwidget.h"
#include "volumeeditwidget.h"

#include <QScrollBar>

class ScoreEditWidget : public QWidget
{
    Q_OBJECT
public:
    explicit ScoreEditWidget(QWidget *parent = nullptr);

signals:
public slots:
    void onHScroll(int pos);
    void onPitchVScroll(int pos);
    void pitchRangeChanged(float minPitch, float maxPitch);
    void xPositionChanged(int position);
    void xScaleChanged(float scale);
protected:
    PitchEditWidget * _pitchEditWidget;
    VolumeEditWidget * _volumeEditWidget;
    QScrollBar * _hScrollBar;
    QScrollBar * _pitchVScrollBar;
    QScrollBar * _volumeVScrollBar;

    PitchAndVolumeTrack _track;

    int _xlength;
    int _xposition;
    int _xscale;
    int _hscrollDiv;

    void updateX();
    void updateHScroll();
    void resizeEvent(QResizeEvent *event) override;
};

#endif // SCOREEDITWIDGET_H
