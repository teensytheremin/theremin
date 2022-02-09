#include "mainwindow.h"

#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QLabel>
#include <QMenu>
#include <QMenuBar>
#include <QStatusBar>
#include <QToolBar>

QIcon iconFromResource(QString name) {
    QIcon icon;
    icon.addFile(QString(":/resources/icons/16x16/%1.png").arg(name), QSize(16,16));
    icon.addFile(QString(":/resources/icons/32x32/%1.png").arg(name), QSize(32,32));
    return icon;
}

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    //QVBoxLayout *mainLayout = new QVBoxLayout;
    QStatusBar *statusBar = new QStatusBar(this);
    setStatusBar(statusBar);
    setWindowIcon(iconFromResource("app-icon"));

    _scoreEditWidget = new ScoreEditWidget(this);
    //mainLayout->addWidget(_pitchEditWidget);

    //QWidget * centralWidget = new QWidget(this);
    //centralWidget->setLayout(mainLayout);
    setCentralWidget(_scoreEditWidget);
    setWindowTitle("Theremin Score Editor v0.1");


    _fileMenu = menuBar()->addMenu(tr("&File"));
    _editMenu = menuBar()->addMenu(tr("&Edit"));
    _viewMenu = menuBar()->addMenu(tr("&View"));


    _actionFileNew = new QAction(iconFromResource("document-new"), tr("&New"), this);
    _actionFileNew->setShortcuts(QKeySequence::New);
    _actionFileNew->setStatusTip(tr("Create a new file"));

    _actionFileOpen = new QAction(iconFromResource("document-open"), tr("&Open"), this);
    _actionFileOpen->setShortcuts(QKeySequence::Open);
    _actionFileOpen->setStatusTip(tr("Open existing file"));

    _actionFileSave = new QAction(iconFromResource("document-save"), tr("&Save"), this);
    _actionFileSave->setShortcuts(QKeySequence::Save);
    _actionFileSave->setStatusTip(tr("Save file"));

    _actionFileSaveAs = new QAction(tr("Save &as"), this);
    _actionFileSaveAs->setShortcuts(QKeySequence::Save);
    _actionFileSaveAs->setStatusTip(tr("Save file as..."));

    _actionFileExit = new QAction(iconFromResource("application-exit"), tr("E&xit"), this);
    _actionFileExit->setShortcuts(QKeySequence::Close);
    _actionFileExit->setStatusTip(tr("Exit"));

    _fileMenu->addAction(_actionFileNew);
    _fileMenu->addAction(_actionFileOpen);
    _fileMenu->addAction(_actionFileSave);
    _fileMenu->addAction(_actionFileSaveAs);
    _fileMenu->addAction(_actionFileExit);

    QToolBar *fileToolBar = addToolBar(tr("File"));
    fileToolBar->setIconSize(QSize(24,24));
    fileToolBar->addAction(_actionFileNew);
    fileToolBar->addAction(_actionFileOpen);
    fileToolBar->addAction(_actionFileSave);
    //fileToolBar->addAction(_actionFileExit);

}

MainWindow::~MainWindow()
{
}

