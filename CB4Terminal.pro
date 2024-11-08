QT += quick serialport qml core
QT += quickcontrols2

VERSION = 2.3.0.0 #major.minor.patch.build
DEFINES += APP_VERSION_NAME=\\\"$$VERSION\\\"
DEFINES += APP_VERSION_CODE=\\\"$$VERSION\\\"

windows: {

    #check if release or debug
    CONFIG(release, debug|release) {
        DESTDIR = $$PWD/bin/windows/release
        appinfo.depends = FORCE
        appinfo.commands = -$(DEL_FILE) release\\appinfo.o $$escape_expand(\n\t)-$(DEL_FILE) release\\appinfo.obj
        QMAKE_EXTRA_TARGETS += appinfo
        PRE_TARGETDEPS += appinfo
        QMAKE_POST_LINK =  windeployqt $$shell_path($$DESTDIR/$${TARGET}.exe) --qmldir $$PWD/qml --no-translations
    } else {
#        DESTDIR = $$PWD/bin/windows/debug
        delPlugin.depends = FORCE
        delPlugin.commands =  -$$QMAKE_DEL_TREE plugin
        QMAKE_EXTRA_TARGETS += delPlugin
        PRE_TARGETDEPS += delPlugin
        appinfo.depends = FORCE
        appinfo.commands = -$(DEL_FILE) debug\\appinfo.o $$escape_expand(\n\t)-$(DEL_FILE) debug\\appinfo.obj
        QMAKE_EXTRA_TARGETS += appinfo
        PRE_TARGETDEPS += appinfo
    }

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
        commandhistorymanager.cpp \
        singleton/componentcachemanager.cpp \
        main.cpp \
        singleton/crc.cpp \
        singleton/fileutils.cpp \
        singleton/integer64.cpp \
        singleton/pluginInfo.cpp \
        singleton/myscreeninfo.cpp \
        qmlapp.cpp \
        serialmanager.cpp \
        singleton/softwarelauncher.cpp \
        tools/appinfo.cpp \
        tools/crashReportTool.cpp \
        viewpage/viewpage.cpp

HEADERS += \
        commandhistorymanager.h \
        singleton/componentcachemanager.h \
        singleton/crc.h \
        singleton/fileutils.h \
        singleton/integer64.h \
        singleton/pluginInfo.h \
        singleton/myscreeninfo.h \
        qmlapp.h \
        serialmanager.h \
        singleton/softwarelauncher.h \
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

DISTFILES += \
    android/AndroidManifest.xml

contains(ANDROID_TARGET_ARCH,arm64-v8a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
}

