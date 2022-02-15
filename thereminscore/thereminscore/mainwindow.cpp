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
    _playMenu = menuBar()->addMenu(tr("&Play"));
    _drawMenu = menuBar()->addMenu(tr("&Draw"));


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
    _fileMenu->addSeparator();
    _fileMenu->addAction(_actionFileExit);

    _actionEditUndo = new QAction(iconFromResource("edit-undo"), tr("&Undo"), this);
    _actionEditUndo->setShortcuts(QKeySequence::Undo);
    _actionEditUndo->setStatusTip(tr("Undo"));

    _actionEditRedo = new QAction(iconFromResource("edit-redo"), tr("Redo"), this);
    _actionEditRedo->setShortcuts(QKeySequence::Redo);
    _actionEditRedo->setStatusTip(tr("Redo"));

    _editMenu->addAction(_actionEditUndo);
    _editMenu->addAction(_actionEditRedo);

    _actionPlayStart = new QAction(iconFromResource("media-playback-start"), tr("Play"), this);
    _actionPlayStart->setStatusTip(tr("Playback start"));

    _actionPlayStop = new QAction(iconFromResource("media-playback-stop"), tr("Stop"), this);
    _actionPlayStop->setStatusTip(tr("Playback start"));

    _actionPlayPause = new QAction(iconFromResource("media-playback-pause"), tr("Pause"), this);
    _actionPlayPause->setStatusTip(tr("Playback start"));

    _playMenu->addAction(_actionPlayStart);
    _playMenu->addAction(_actionPlayPause);
    _playMenu->addAction(_actionPlayStop);

    QActionGroup * drawGroup = new QActionGroup(this);
    //drawGroup->
    _actionDrawPoint1 = new QAction(iconFromResource("draw-point1"), tr("Point Narrow"), this);
    _actionDrawPoint1->setStatusTip(tr("Draw point narrow"));
    _actionDrawPoint1->setActionGroup(drawGroup);
    _actionDrawPoint1->setCheckable(true);
    _actionDrawPoint1->setChecked(true);
    _actionDrawPoint2 = new QAction(iconFromResource("draw-point2"), tr("Point Medium"), this);
    _actionDrawPoint2->setStatusTip(tr("Draw point medium"));
    _actionDrawPoint2->setActionGroup(drawGroup);
    _actionDrawPoint2->setCheckable(true);
    _actionDrawPoint3 = new QAction(iconFromResource("draw-point3"), tr("Point Wide"), this);
    _actionDrawPoint3->setStatusTip(tr("Draw point wide"));
    _actionDrawPoint3->setActionGroup(drawGroup);
    _actionDrawPoint3->setCheckable(true);

    _drawMenu->addAction(_actionDrawPoint1);
    _drawMenu->addAction(_actionDrawPoint2);
    _drawMenu->addAction(_actionDrawPoint3);

    QToolBar *fileToolBar = createToolBar(tr("File"));
    fileToolBar->addAction(_actionFileNew);
    fileToolBar->addAction(_actionFileOpen);
    fileToolBar->addAction(_actionFileSave);

    QToolBar *playToolBar = createToolBar(tr("Play"));
    playToolBar->addAction(_actionPlayStart);
    playToolBar->addAction(_actionPlayPause);
    playToolBar->addAction(_actionPlayStop);

    QToolBar *editToolBar = createToolBar(tr("Edit"));
    editToolBar->addAction(_actionEditUndo);
    editToolBar->addAction(_actionEditRedo);

    QToolBar *drawToolBar = createToolBar(tr("Draw"));
    drawToolBar->addAction(_actionDrawPoint1);
    drawToolBar->addAction(_actionDrawPoint2);
    drawToolBar->addAction(_actionDrawPoint3);

    _drawingTools[0].toolType = DRAW_POINT;
    _drawingTools[0].maxVelocity = 0.01f;
    _drawingTools[0].maxAcceleration = 0.001f;

    _drawingTools[1].toolType = DRAW_POINT;
    _drawingTools[1].maxVelocity = 0.001f;
    _drawingTools[1].maxAcceleration = 0.0001f;

    _drawingTools[2].toolType = DRAW_POINT;
    _drawingTools[2].maxVelocity = 0.0003f;
    _drawingTools[2].maxAcceleration = 0.00003f;

    _scoreEditWidget->setDrawingTool(&_drawingTools[0]);
    connect(_actionDrawPoint1, &QAction::toggled,
            [=](bool checked) {
                    if (checked) _scoreEditWidget->setDrawingTool(&_drawingTools[0]);
                }
            );
    connect(_actionDrawPoint2, &QAction::toggled,
            [=](bool checked) {
                    if (checked) _scoreEditWidget->setDrawingTool(&_drawingTools[1]);
                }
            );
    connect(_actionDrawPoint3, &QAction::toggled,
            [=](bool checked) {
                    if (checked) _scoreEditWidget->setDrawingTool(&_drawingTools[2]);
                }
            );
}

QToolBar * MainWindow::createToolBar(QString name) {
    QToolBar *tb = addToolBar(name);
    tb->setFloatable(false);
    tb->setAllowedAreas(Qt::ToolBarArea::LeftToolBarArea);
    addToolBar(Qt::ToolBarArea::LeftToolBarArea, tb);
    tb->setIconSize(QSize(24,24));
    return tb;
}

MainWindow::~MainWindow()
{
}

