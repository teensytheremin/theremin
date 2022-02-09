#include "volumeeditwidget.h"
#include <QPainter>
#include <QBrush>
#include <QPen>
#include <QMouseEvent>

QSize VolumeEditWidget::sizeHint() const
{
    return QSize(800, 200);
}

QSize VolumeEditWidget::minimumSizeHint() const
{
    return QSize(600, 100);
}


VolumeEditWidget::VolumeEditWidget(PitchAndVolumeTrack * data, QWidget *parent) : TrackWidgetBase(data, parent), _lastxpos(0)
{

}

float VolumeEditWidget::yToGain(int y) const {
    if (height() <= 0)
        return MIN_VOLUME_DB;
    return MAX_VOLUME_DB + y * (MIN_VOLUME_DB - MAX_VOLUME_DB) / height();
}

int VolumeEditWidget::gainToY(float gain) const {
    return static_cast<int>(height() * (gain - MAX_VOLUME_DB) / (MIN_VOLUME_DB - MAX_VOLUME_DB));
}

static uint32_t VOLUME_BG_COLORS[12] = {
    0xff8c0001,
    0xff884002,
    0xff846004,
    0xff807008,
    0xff608010,
    0xff408818,
    0xff308020,
    0xff407038,
    0xff306050,
    0xff205060,
    0xff104070,
    0xff001080,
};

void VolumeEditWidget::paintEvent(QPaintEvent * /* event */)
{
    QPainter painter(this);
    QBrush brush(QColor(220, 255, 200));

    int penWidth = 2;
    Qt::PenStyle style = Qt::PenStyle(Qt::SolidLine);
    Qt::PenCapStyle cap = Qt::PenCapStyle(Qt::RoundCap);
    Qt::PenJoinStyle join = Qt::PenJoinStyle(Qt::RoundJoin);
    QPen pen(QColor(220, 220, 255), penWidth, style, cap, join);

    painter.setPen(pen);
    painter.setBrush(brush);
    int w = width();
    int h = height();

    //int range = 120; // +10..-110
    int dbDecades = (int)((MAX_VOLUME_DB - MIN_VOLUME_DB) / 10.0f + 0.5f);
    for (int i = 0; i < dbDecades; i++) {
        int topy = i * h / dbDecades;
        int bottomy = (i + 10) * h / dbDecades;
        uint64_t color = blendARGB(VOLUME_BG_COLORS[i], 0xff000000, 96);
        painter.fillRect(QRect(0, topy, w, bottomy-topy), color);
    }

    //painter.fillRect(QRect(0, 0, w, h), brush);

    QVector<QPointF> points;
    int startPos = _xposition;
    int maxPos = _xlength;
    float lastX = -1;
    float lastY = -1;
    for (int pos = startPos; pos < maxPos; pos++) {
        PitchAndVolume data = _data->get(pos);
        float pointX = (pos - _xposition) / (float)_xscale;
        //return static_cast<int>(height() * (pitch - _maxpitch) / (_minpitch - _maxpitch));
        float gain = clampVolume(data.volume);
        float pointY = (height() * (gain - MAX_VOLUME_DB) / (MIN_VOLUME_DB - MAX_VOLUME_DB));
        float deltax = abs(pointX - lastX);
        float deltay = abs(pointY - lastY);
        if (deltax > 0.5f || deltay > 0.5f) {
            points.append(QPointF(pointX, pointY));
            lastX = pointX;
            lastY = pointY;
        }
    }
    painter.drawPolyline(points);



    dimTail(painter);
    drawMeterMarks(painter);
}

void VolumeEditWidget::wheelEvent(QWheelEvent * event) {
    TrackWidgetBase::wheelEvent(event);
}

#define MAX_DB_PER_SECOND 250.0f
#define MAX_VOLUME_VELOCITY (MAX_DB_PER_SECOND / SCORE_FRAME_RATE)

void VolumeEditWidget::mouseMoveEvent(QMouseEvent *event) {
    int x = event->pos().x();
    int y = event->pos().y();
    int xpos = xToPos(x);
    float volume = yToGain(y);
    if (event->buttons() & Qt::MouseButton::LeftButton) {
        if (_lastxpos != xpos) {
            // interpolate range
            float startVolume = _data->get(_lastxpos).volume;
            _data->setVolumeInterpolated(_lastxpos, startVolume, xpos, volume);
            _lastxpos = xpos;
        }
        _data->setVolumeVelocityLimited(xpos, volume, MAX_VOLUME_VELOCITY);
        event->accept();
        update();
    }
}


void VolumeEditWidget::mousePressEvent(QMouseEvent *event) {
    int x = event->pos().x();
    int y = event->pos().y();
    int xpos = xToPos(x);
    float volume = yToGain(y);
    if (event->button() == Qt::MouseButton::LeftButton) {
        _data->setVolumeVelocityLimited(xpos, volume, MAX_VOLUME_VELOCITY);
        _lastxpos = xpos;
        event->accept();
        update();
    }
}

void VolumeEditWidget::mouseReleaseEvent(QMouseEvent *event) {

}
