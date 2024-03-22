QT += quick serialport qml core
QT += quickcontrols2

windows: {
#    build_nr.commands =
#    build_nr.depends = FORCE
#    QMAKE_EXTRA_TARGETS += build_nr
#    PRE_TARGETDEPS += build_nr
#    HEADERS  += $$PWD/cb4tools/build_info.h
}

android: {
#   QT += androidextras
#   QMAKE_LINK += -nostdlib++
#   QMAKE_LFLAGS += -stdlib=libstdc++
}
CONFIG += c++11


# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        componentcachemanager.cpp \
        main.cpp \
        pluginInfo.cpp \
        qml/heatmapdata.cpp \
        qml/myscreeninfo.cpp \
        qmlapp.cpp \
        serialmanager.cpp \
        viewpage/viewpage.cpp

HEADERS += \
        cb4tools/debug_info.h \
        componentcachemanager.h \
        pluginInfo.h \
        qml/heatmapdata.h \
        qml/myscreeninfo.h \
        qmlapp.h \
        script/build_inc.bat \
        serialmanager.h \
        viewpage/viewpage.h

DEPENDPATH *= $${INCLUDEPATH}


RESOURCES += \
        image.qrc \
        plugins.qrc \
        qrc.qrc

RC_ICONS = qml/icon/logo1.ico

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =


# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
}

