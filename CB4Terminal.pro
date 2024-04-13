QT += quick serialport qml core
QT += quickcontrols2

VERSION = 2.1.0.1 #major.minor.patch.build
DEFINES += APP_VERSION_NAME=\\\"$$VERSION\\\"
DEFINES += APP_VERSION_CODE=\\\"$$VERSION\\\"

windows: {

    #check if release or debug
    CONFIG(release, debug|release) {
        DESTDIR = $$PWD/bin/windows/release
    } else {
        DESTDIR = $$PWD/bin/windows/debug
    }
    appinfo.obj.depends = FORCE
    QMAKE_EXTRA_TARGETS += appinfo.obj
    PRE_TARGETDEPS += appinfo.obj

    QMAKE_POST_LINK =  windeployqt $$shell_path($$DESTDIR/$${TARGET}.exe) --qmldir $$PWD/qml --no-translations
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
        tools/appinfo.cpp \
        tools/crashReportTool.cpp \
        viewpage/viewpage.cpp

HEADERS += \
        cb4tools/debug_info.h \
        componentcachemanager.h \
        pluginInfo.h \
        qml/heatmapdata.h \
        qml/myscreeninfo.h \
        qmlapp.h \
        serialmanager.h \
        tools/appinfo.h \
        tools/crashReportTool.h \
        tools/debug_info.h \
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

