#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
//#include "pitcheditwidget.h"
#include "scoreeditwidget.h"

class MainWindow : public QMainWindow
{
    Q_OBJECT

    ScoreEditWidget *_scoreEditWidget;
    QMenu *_fileMenu;
    QMenu *_editMenu;
    QMenu *_viewMenu;
    QMenu *_playMenu;
    QMenu *_drawMenu;
    QAction *_actionFileNew;
    QAction *_actionFileOpen;
    QAction *_actionFileSave;
    QAction *_actionFileSaveAs;
    QAction *_actionFileExit;
    QAction *_actionEditUndo;
    QAction *_actionEditRedo;
    QAction *_actionPlayStart;
    QAction *_actionPlayStop;
    QAction *_actionPlayPause;
    QAction *_actionDrawPoint1;
    QAction *_actionDrawPoint2;
    QAction *_actionDrawPoint3;
private:
    QToolBar * createToolBar(QString name);
    DrawingTool _drawingTools[3];
public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
};
#endif // MAINWINDOW_H
