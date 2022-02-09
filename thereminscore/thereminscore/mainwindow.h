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
    QAction *_actionFileNew;
    QAction *_actionFileOpen;
    QAction *_actionFileSave;
    QAction *_actionFileSaveAs;
    QAction *_actionFileExit;
public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
};
#endif // MAINWINDOW_H
