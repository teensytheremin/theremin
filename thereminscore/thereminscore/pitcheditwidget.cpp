#include "pitcheditwidget.h"
#include <QPainter>
#include <QBrush>
#include <QPen>
#include <QWheelEvent>

PitchEditWidget::PitchEditWidget(PitchAndVolumeTrack * data, QWidget *parent) : TrackWidgetBase(TRACK_PITCH, data, parent),
    _minpitch(43.5), _maxpitch(68.5)
{

}


QSize PitchEditWidget::sizeHint() const
{
    return QSize(800, 600);
}

QSize PitchEditWidget::minimumSizeHint() const
{
    return QSize(600, 300);
}

void PitchEditWidget::setNoteRange(float minPitch, float maxPitch) {
    float newRange = maxPitch - minPitch;
    if (newRange > MAX_NOTE)
        newRange = MAX_NOTE;
    else if (newRange < 3.0)
        newRange = 3.0;
    if (maxPitch > MAX_NOTE) {
        maxPitch = MAX_NOTE;
        minPitch = maxPitch - newRange;
    }
    if (minPitch < 0) {
        minPitch = 0;
        maxPitch = newRange;
    }
    _minpitch = minPitch;
    _maxpitch = maxPitch;
    update();
}

// C D E .. A B
static int note_colors[12] {
    0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0
};

static uint32_t white_colors[16] {
    0xff525252,
    0xff5a5a5a,
    0xff606060,
    0xff646464,
    0xff676767,
    0xff6a6a6a,
    0xff6f6f6f,
    0xff727272,

    0xff727272,
    0xff6f6f6f,
    0xff6a6a6a,
    0xff676767,
    0xff646464,
    0xff606060,
    0xff5a5a5a,
    0xff525252,
};

static uint32_t black_colors[16] {
    0xff343434,
    0xff3a3a3a,
    0xff414141,
    0xff444444,
    0xff474747,
    0xff4a4a4a,
    0xff4f4f4f,
    0xff565656,

    0xff565656,
    0xff4f4f4f,
    0xff4a4a4a,
    0xff474747,
    0xff444444,
    0xff414141,
    0xff3a3a3a,
    0xff343434,
};

static bool isBlackNote(int noteIndex) {
    int i = (noteIndex % 12);
    if (i < 0)
        i = 0;
    return note_colors[i] == 1;
}

static const char * NOTE_NAMES[12] = {
    "C",  //0
    "C#", //1
    "D",  //2
    "D#", //3
    "E",  //4
    "F",  //5
    "F#", //6
    "G",  //7
    "G#", //8
    "A",  //9
    "A#", //10
    "B", //11
};

static const uint32_t OCTAVE_BASE_COLORS[11] = {
    0xfffe7474, // -1
    0xfffeb074, // 0
    0xfffef674, // 1
    0xffbbfe74, // 2
    0xff74fea1, // 3
    0xff74feef, // 4
    0xff74b3fe, // 5
    0xff8a74fe, // 6
    0xffd974fe, // 7
    0xfffe74d5, // 8
    0xfffe74a8, // 9
};

static const int CENTS_BRIGHTNESS_128[128] = {
    191, // 0 : 0.7500
    193, // 1 : 0.7578
    195, // 2 : 0.7654
    197, // 3 : 0.7729
    199, // 4 : 0.7803
    201, // 5 : 0.7875
    203, // 6 : 0.7947
    204, // 7 : 0.8017
    206, // 8 : 0.8086
    208, // 9 : 0.8154
    210, // 10 : 0.8220
    211, // 11 : 0.8286
    213, // 12 : 0.8350
    214, // 13 : 0.8412
    216, // 14 : 0.8474
    218, // 15 : 0.8535
    219, // 16 : 0.8594
    221, // 17 : 0.8652
    222, // 18 : 0.8708
    223, // 19 : 0.8764
    225, // 20 : 0.8818
    226, // 21 : 0.8871
    227, // 22 : 0.8923
    229, // 23 : 0.8974
    230, // 24 : 0.9023
    231, // 25 : 0.9072
    232, // 26 : 0.9119
    234, // 27 : 0.9164
    235, // 28 : 0.9209
    236, // 29 : 0.9252
    237, // 30 : 0.9294
    238, // 31 : 0.9335
    239, // 32 : 0.9375
    240, // 33 : 0.9413
    241, // 34 : 0.9451
    242, // 35 : 0.9487
    243, // 36 : 0.9521
    244, // 37 : 0.9555
    244, // 38 : 0.9587
    245, // 39 : 0.9619
    246, // 40 : 0.9648
    247, // 41 : 0.9677
    247, // 42 : 0.9705
    248, // 43 : 0.9731
    249, // 44 : 0.9756
    249, // 45 : 0.9780
    250, // 46 : 0.9802
    250, // 47 : 0.9824
    251, // 48 : 0.9844
    251, // 49 : 0.9863
    252, // 50 : 0.9880
    252, // 51 : 0.9897
    253, // 52 : 0.9912
    253, // 53 : 0.9926
    253, // 54 : 0.9939
    254, // 55 : 0.9951
    254, // 56 : 0.9961
    254, // 57 : 0.9970
    254, // 58 : 0.9978
    255, // 59 : 0.9985
    255, // 60 : 0.9990
    255, // 61 : 0.9995
    255, // 62 : 0.9998
    255, // 63 : 0.9999
    255, // 64 : 1.0000
    255, // 65 : 0.9999
    255, // 66 : 0.9998
    255, // 67 : 0.9995
    255, // 68 : 0.9990
    255, // 69 : 0.9985
    254, // 70 : 0.9978
    254, // 71 : 0.9970
    254, // 72 : 0.9961
    254, // 73 : 0.9951
    253, // 74 : 0.9939
    253, // 75 : 0.9926
    253, // 76 : 0.9912
    252, // 77 : 0.9897
    252, // 78 : 0.9880
    251, // 79 : 0.9863
    251, // 80 : 0.9844
    250, // 81 : 0.9824
    250, // 82 : 0.9802
    249, // 83 : 0.9780
    249, // 84 : 0.9756
    248, // 85 : 0.9731
    247, // 86 : 0.9705
    247, // 87 : 0.9677
    246, // 88 : 0.9648
    245, // 89 : 0.9619
    244, // 90 : 0.9587
    244, // 91 : 0.9555
    243, // 92 : 0.9521
    242, // 93 : 0.9487
    241, // 94 : 0.9451
    240, // 95 : 0.9413
    239, // 96 : 0.9375
    238, // 97 : 0.9335
    237, // 98 : 0.9294
    236, // 99 : 0.9252
    235, // 100 : 0.9209
    234, // 101 : 0.9164
    232, // 102 : 0.9119
    231, // 103 : 0.9072
    230, // 104 : 0.9023
    229, // 105 : 0.8974
    227, // 106 : 0.8923
    226, // 107 : 0.8871
    225, // 108 : 0.8818
    223, // 109 : 0.8764
    222, // 110 : 0.8708
    221, // 111 : 0.8652
    219, // 112 : 0.8594
    218, // 113 : 0.8535
    216, // 114 : 0.8474
    214, // 115 : 0.8412
    213, // 116 : 0.8350
    211, // 117 : 0.8286
    210, // 118 : 0.8220
    208, // 119 : 0.8154
    206, // 120 : 0.8086
    204, // 121 : 0.8017
    203, // 122 : 0.7947
    201, // 123 : 0.7875
    199, // 124 : 0.7803
    197, // 125 : 0.7729
    195, // 126 : 0.7654
    193, // 127 : 0.7578
};

uint32_t getNoteBackgroundColor(int noteMul128) {
    int noteIndex = noteMul128 >> 7;
    int octaveIndex = noteIndex / 12;
    int noteCents = noteMul128 & 127;
    uint32_t octaveColor = blendARGB(OCTAVE_BASE_COLORS[octaveIndex], 0xff404040, 220);
    bool isBlack = isBlackNote(noteIndex);
    uint32_t noteColor = isBlack ? blendARGB(0xff000000, octaveColor, 192) : octaveColor;
    int centBrightness = CENTS_BRIGHTNESS_128[noteCents];
    return blendARGB(0xff000000, noteColor, centBrightness);
}

void PitchEditWidget::paintEvent(QPaintEvent * /* event */)
{
    QPainter painter(this);

    int penWidth = 2;
    Qt::PenStyle style = Qt::PenStyle(Qt::SolidLine);
    Qt::PenCapStyle cap = Qt::PenCapStyle(Qt::RoundCap);
    Qt::PenJoinStyle join = Qt::PenJoinStyle(Qt::RoundJoin);
    QPen pen(QColor(240, 240, 220), penWidth, style, cap, join);
    painter.setPen(pen);

    QBrush brush(QColor(220, 255, 200));
    painter.setBrush(brush);

    int w = width();
    int h = height();
    painter.fillRect(QRect(0, 0, w, h), brush);
    //int y0 = 0;
    for (int y = 0; y < h; y++) {
        float note = yToValue(y);
        int noteMul128 = static_cast<int>((note + 0.5f) * 128.0f);
        uint32_t bgColor = getNoteBackgroundColor(noteMul128);
        int inote = static_cast<int>(note + 0.5f);
        //int inotefrac = (static_cast<int>((note + 0.5f) * 16)) & 15;
        int noteMiddleY = valueToY(inote);
        //float nextnote = yToPitch(y + 1);
        //int inextnote = static_cast<int>(nextnote + 0.5f);
        bool isMiddleLine = (y == noteMiddleY);
        uint64_t color = isMiddleLine ? blendARGB(bgColor, 0xffffffff, 64) : bgColor;
//        uint64_t color = isBlackNote(inote)
//                ? (isMiddleLine ? 0xFF808080 : bgColor)  // black
//                : (isMiddleLine ? 0xFFc0d0d0 : bgColor); // white

        painter.fillRect(QRect(0, y, w, 1), color);
    }

    QVector<QPointF> points;
    int startPos = _xposition;
    int maxPos = _xlength;
    float lastX = -1;
    float lastY = -1;
    for (int pos = startPos; pos < maxPos; pos++) {
        PitchAndVolume data = _data->get(pos);
        float pointX = (pos - _xposition) / (float)_xscale;
        //return static_cast<int>(height() * (pitch - _maxpitch) / (_minpitch - _maxpitch));
        float pointY = (height() * (data.note - _maxpitch) / (_minpitch - _maxpitch));
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

    float topnote = yToValue(0);
    float bottomnote = yToValue(height());
    int itopnote = static_cast<int>(topnote);
    int ibottomnote = static_cast<int>(bottomnote);
    painter.setPen(QPen(QColor(220, 255, 255, 140)));
    //painter.setBrush(QBrush(QColor(220, 220, 220, 140)));
    QFontMetrics metrics(painter.font());
    int fontH = metrics.height();
    float fontHNotes = topnote - yToValue(0 + fontH);
    for (int i = ibottomnote; i <= itopnote; i++ ) {
        int octave = i / 12;
        int noteInsideOctave = i % 12;
        if (noteInsideOctave == 0 || (noteInsideOctave == 4 && fontHNotes<4.5) || (noteInsideOctave == 9 && fontHNotes < 2.5)) {
            int y = valueToY(i);
            QString text = QString("%1%2").arg(NOTE_NAMES[noteInsideOctave], QString::number(octave-1));
            QSize sz = metrics.size(Qt::TextSingleLine, text);
            painter.drawText(QRect(w - sz.width(), y - metrics.height()/2, sz.width(), sz.height()), text); //Qt::AlignVCenter,
            painter.fillRect(QRect(w - sz.width()-5, y, 5, 1), 0xffffffff);
        }
    }

    drawEditLines(painter);

}

void PitchEditWidget::wheelEvent(QWheelEvent * event) {
    int x = event->position().toPoint().x();
    int y = event->position().toPoint().y();
    Qt::MouseButtons mouseFlags = event->buttons();
    Qt::KeyboardModifiers keyFlags = event->modifiers();
    QPoint angleDelta = event->angleDelta();
    Qt::ScrollPhase phase = event->phase();
    //qDebug("wheelEvent(x=%d, y=%d, mouse=%x, keymodifiers=%x delta=(%d %d) phase=%d)", x, y, mouseFlags, keyFlags, angleDelta.x(), angleDelta.y(), phase);
    int vScrollDelta = isVScrollEvent(event);
    if (vScrollDelta) {
        // vertical scroll
        float notesPerPixel = visibleValueRange() / height();
        float notesDelta = vScrollDelta * notesPerPixel;
        setNoteRange(_minpitch + notesDelta, _maxpitch + notesDelta);
        emit pitchRangeChanged(_minpitch, _maxpitch);
        update();
        event->accept();
        return;
    }
    int vscaleDelta = isVScaleEvent(event);
    if (vscaleDelta) {

        // vertical zoom
        int xdelta = vscaleDelta;
        float scaleBase = 256.0f;
        float oldScale = _maxpitch - _minpitch;
        float newScale = (xdelta > 0)
                ? (oldScale * (scaleBase + xdelta) / scaleBase)
                : (oldScale * scaleBase / (scaleBase - xdelta));
        if (newScale > MAX_NOTE)
            newScale = MAX_NOTE;
        if (newScale < 3.0f)
            newScale = 3.0f;

        // y to pitch
        //return _maxpitch + y * (_minpitch - _maxpitch) / height();


        //int y = event->y();
        int h = height();
        float oldpos = _minpitch + (h - y) * oldScale / h;
        float newpos = _minpitch + (h - y) * newScale / h;
        float posCorrection = -(oldpos - newpos);

//        qDebug("Note range scale: oldScale = %f newScale=%f oldpos=%f newpos=%f poscorrection=%f", oldScale, newScale,
//               oldpos, newpos, posCorrection
//               );

        if (oldScale != newScale) {
            float newMin = _minpitch - posCorrection;
            if (newMin + newScale > MAX_NOTE) {
                newMin = MAX_NOTE - newScale;
            }
            if (newMin < 0)
                newMin = 0;
            setNoteRange(newMin, newMin + newScale);
            emit pitchRangeChanged(newMin, newMin + newScale);
        }
        update();
        event->accept();
        return;
    }
    TrackWidgetBase::wheelEvent(event);
}
