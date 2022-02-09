QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    main.cpp \
    mainwindow.cpp \
    noteutil.cpp \
    pitchandvolumetrack.cpp \
    pitcheditwidget.cpp \
    scoreeditwidget.cpp \
    thereminscoreproject.cpp \
    trackwidgetbase.cpp \
    volumeeditwidget.cpp

HEADERS += \
    mainwindow.h \
    noteutil.h \
    pitchandvolumetrack.h \
    pitcheditwidget.h \
    scoreeditwidget.h \
    thereminscoreproject.h \
    trackwidgetbase.h \
    volumeeditwidget.h

RESOURCES += \
    thereminscore.qrc

RC_ICONS = thereminscore.ico

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
