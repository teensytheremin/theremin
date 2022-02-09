#include "mainwindow.h"

#include <QApplication>
#include <QDebug>

#include "pitchandvolumetrack.h"

int main(int argc, char *argv[])
{
    for (int i = 0; i < 128; i++) {
        float freq = midiNoteToFrequency((float)i);
        float note = frequencyToMidiNote(freq);
        qDebug("Note %3d\t%9.3f\t%7.3f", i, freq, note);
    }
    for (int db = 0; db <= 120; db++) {
        float gain = dbToGain(db * -1.0);
        float dbf = gainToDb(gain);
        qDebug("-%2d dB:\t%.7f\t%.3f\t%.2f", db, gain, dbf, 1.0f/gain);
    }
    qDebug("static const int CENTS_BRIGHTNESS_128[128] = {");
    for (int i = 0; i < 128; i++) {
        float x = (i - 64) / 64.0f * 0.5f;
        float x2 = 1.0f - x*x;
        int n = static_cast<int>(x2 * 255.5f);
        qDebug("    %d, // %d : %.4f", n, i, x2);
    }
    qDebug("};");
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
