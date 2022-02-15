#include "mainwindow.h"

#include <QApplication>
#include <QDebug>

#include "pitchandvolumetrack.h"

void testPolyInterpolator() {
    PolyInterpolator solver;
    solver.init(-100.0f, 100.0f, 0.1f, 0.01f);
    solver.start(4, 1, 5.0f, 6.0f, 6.9f);
    solver.end(10, 7.0f, 6.9f, 6.6f);
    for (int i = 4; i <= 12; i++) {
        qDebug("%d\t%f\t%f\t%f", i, solver.eval(i), solver.velocityAt(i), solver.accelerationAt(i));
    }
    qDebug("testPolyInterpolator() test passed");
}

void testPolyInterpolator5() {
    PolyInterpolator solver;
    solver.init(-100.0f, 100.0f, 0.1f, 0.01f);
    IndexedFloats points;
    points.append(IndexedFloat(-5, 10.2f));
    points.append(IndexedFloat(-3, 5.1f));
    points.append(IndexedFloat(-1, 4.0f));
    points.append(IndexedFloat(3, 1.0f));
    points.append(IndexedFloat(7, 3.0f));
    solver.setPoints(points);
    solver.solve();
    for (int i = points.first().index; i <= points.last().index; i++) {
        qDebug("%d\t%f\t%f\t%f", i, solver.eval(i), solver.velocityAt(i), solver.accelerationAt(i));
    }
    qDebug("testPolyInterpolator(5) test passed");
}

void testNoteUtils() {
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
}

int main(int argc, char *argv[])
{
    testPolyInterpolator();
    testPolyInterpolator5();
//    testCubeSolver();
    qDebug("};");
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
