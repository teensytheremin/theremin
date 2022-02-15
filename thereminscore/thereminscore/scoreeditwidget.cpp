#include "scoreeditwidget.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QSplitter>
#include <math.h>

void initTrack(PitchAndVolumeTrack & track, int len) {
    track.setLength(len);
    for (int i = 0; i < len; i++) {
        float x = i / 350.0f;
        float pitch = sinf(x) + 0.5f*sinf(x*1.334f + 2) + 0.4f*sinf(x*2.3123 + 1) + 0.3f*sinf(x*3.0123);
        float volume = sinf(x*1.134f) + 1.2f*sinf(x*1.3134f + 0.4f) + 0.3f*sinf(x*4.0123 + 0.5f) + 0.2f*sinf(x*5.0123);
        pitch = pitch * 3  + 45.0f;
        volume = volume * 25 - 40;
        track[i].note = pitch;
        track[i].volume = volume;
    }
}

ScoreEditWidget::ScoreEditWidget(QWidget *parent) : QWidget(parent), _drawingTool(nullptr), _xlength(10000), _xposition(0), _xscale(16), _hscrollDiv(1)
{
    initTrack(_track, 20000);
    _xlength = 20000;
    QVBoxLayout *mainLayout = new QVBoxLayout;
    QHBoxLayout *pitchLayout = new QHBoxLayout;
    QHBoxLayout *volumeLayout = new QHBoxLayout;
    _pitchVScrollBar = new QScrollBar(Qt::Orientation::Vertical, this);
    _volumeVScrollBar = new QScrollBar(Qt::Orientation::Vertical, this);
    _pitchEditWidget = new PitchEditWidget(&_track, this);
    _volumeEditWidget = new VolumeEditWidget(&_track, this);

    pitchLayout->addWidget(_pitchEditWidget);
    pitchLayout->addWidget(_pitchVScrollBar);
    volumeLayout->addWidget(_volumeEditWidget);
    volumeLayout->addWidget(_volumeVScrollBar);
    pitchLayout->setContentsMargins(0,0,0,0);
    volumeLayout->setContentsMargins(0,0,0,0);
    pitchLayout->setMargin(0);
    pitchLayout->setSpacing(0);
    volumeLayout->setMargin(0);
    volumeLayout->setSpacing(0);

    QWidget * pitchWidget = new QWidget(this);
    pitchWidget->setLayout(pitchLayout);
    QWidget * volumeWidget = new QWidget(this);
    volumeWidget->setLayout(volumeLayout);

    QSplitter * splitter = new QSplitter(Qt::Orientation::Vertical, this);

    splitter->addWidget(pitchWidget);
    splitter->addWidget(volumeWidget);
    splitter->setChildrenCollapsible(false);

    mainLayout->setMargin(0);
    mainLayout->setSpacing(0);
    mainLayout->addWidget(splitter);

    _hScrollBar = new QScrollBar(Qt::Orientation::Horizontal, this);

    mainLayout->addWidget(_hScrollBar);
    mainLayout->setContentsMargins(0,0,0,0);

    setLayout(mainLayout);


    pitchRangeChanged(_pitchEditWidget->bottomValue(), _pitchEditWidget->topValue());

    _volumeVScrollBar->setSliderPosition(0);
    _volumeVScrollBar->setMinimum(0);
    _volumeVScrollBar->setMaximum(0);
    _volumeVScrollBar->setPageStep(100);

    QObject::connect(_hScrollBar, &QScrollBar::valueChanged, this, &ScoreEditWidget::onHScroll);
    QObject::connect(_pitchVScrollBar, &QScrollBar::valueChanged, this, &ScoreEditWidget::onPitchVScroll);
    QObject::connect(_pitchEditWidget, &PitchEditWidget::pitchRangeChanged, this, &ScoreEditWidget::pitchRangeChanged);
    QObject::connect(_pitchEditWidget, &PitchEditWidget::xPositionChanged, this, &ScoreEditWidget::xPositionChanged);
    QObject::connect(_volumeEditWidget, &VolumeEditWidget::xPositionChanged, this, &ScoreEditWidget::xPositionChanged);

    QObject::connect(_pitchEditWidget, &PitchEditWidget::xScaleChanged, this, &ScoreEditWidget::xScaleChanged);
    QObject::connect(_volumeEditWidget, &VolumeEditWidget::xScaleChanged, this, &ScoreEditWidget::xScaleChanged);
}

void ScoreEditWidget::resizeEvent(QResizeEvent *event) {
    updateX();
    updateHScroll();
}

void ScoreEditWidget::updateHScroll() {
    int maxpos = _xlength;
    _hscrollDiv = 1;
    while (maxpos > 10000) {
        _hscrollDiv++;
        maxpos = _xlength / _hscrollDiv;
    }
    int pstep = width() * _xscale;
    //if (pstep < 64)
    //    pstep = 64;

    _hScrollBar->setMinimum(0);
    _hScrollBar->setPageStep(pstep / _hscrollDiv);
    _hScrollBar->setMaximum(_xlength / _hscrollDiv);
    _hScrollBar->setSliderPosition(_xposition / _hscrollDiv);
}

void ScoreEditWidget::updateX() {
    _pitchEditWidget->setXLength(_xlength);
    _pitchEditWidget->setXScale(_xscale);
    _pitchEditWidget->setXPosition(_xposition);

    _volumeEditWidget->setXLength(_xlength);
    _volumeEditWidget->setXScale(_xscale);
    _volumeEditWidget->setXPosition(_xposition);

//    int pstep = width() / _xscale;
//    if (pstep < 64)
//        pstep = 64;

    updateHScroll();
}

void ScoreEditWidget::onHScroll(int pos) {
    qDebug("onHScroll %d   _scrollDiv=%d tacking=%d", pos, _hscrollDiv, _hScrollBar->hasTracking());
    int p = pos * _hscrollDiv;
    _xposition = p;
    _pitchEditWidget->setXPosition(_xposition);
    _volumeEditWidget->setXPosition(_xposition);
}

void ScoreEditWidget::onPitchVScroll(int pos) {

//    int pitchPosition = static_cast<int>((127 - _pitchEditWidget->maxPitch())*16 + 0.5f);
      int ipitchRange = static_cast<int>((_pitchEditWidget->topValue() - _pitchEditWidget->bottomValue())*16 + 0.5f);
      int imaxPos = 127 * 16 - ipitchRange;



//    _pitchVScrollBar->setMinimum(0);
//    _pitchVScrollBar->setMaximum(127 * 16 - pitchRange);
//    _pitchVScrollBar->setPageStep(pitchRange);
//    _pitchVScrollBar->setSliderPosition(pitchPosition);


    // top note
    float pitchRange = _pitchEditWidget->topValue() - _pitchEditWidget->bottomValue();
    //float minValue = 0;
    float maxValue = 127.0f - pitchRange;

    float minNote = imaxPos > 0 ? maxValue - maxValue * pos / imaxPos : 0.0f;

//    float p = pos / 16.0f - pitchRange;
    _pitchEditWidget->setNoteRange(minNote, minNote + pitchRange);
    //int pitchPosition = static_cast<int>((127 - _pitchEditWidget->maxPitch())*16 + 0.5f);

}

void ScoreEditWidget::pitchRangeChanged(float minPitch, float maxPitch) {
    int pitchPosition = static_cast<int>((127 - maxPitch)*16 + 0.5f);
    int pitchRange = static_cast<int>((maxPitch - minPitch)*16 + 0.5f);

    _pitchVScrollBar->setMinimum(0);
    _pitchVScrollBar->setMaximum(127 * 16 - pitchRange);
    _pitchVScrollBar->setPageStep(pitchRange);
    _pitchVScrollBar->setSliderPosition(pitchPosition);
}

void ScoreEditWidget::xPositionChanged(int position) {
    _xposition = position;
    _pitchEditWidget->setXPosition(_xposition);
    _volumeEditWidget->setXPosition(_xposition);
    _hScrollBar->setSliderPosition(_xposition / _hscrollDiv);
}

void ScoreEditWidget::xScaleChanged(float scale) {
    _pitchEditWidget->setXScaleF(scale);
    _volumeEditWidget->setXScaleF(scale);
    _xscale = _pitchEditWidget->xScale();

    updateHScroll();
}

void ScoreEditWidget::setDrawingTool(DrawingTool * tool) {
    _drawingTool = tool;
    _pitchEditWidget->setDrawingTool(tool);
    _volumeEditWidget->setDrawingTool(tool);
}
