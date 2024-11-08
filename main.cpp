#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "qmlapp.h"
#include <QDebug>
#ifdef Q_OS_ANDROID
//#include <QtAndroid>
#endif
#include <QQmlApplicationEngine>
#include <QQuickStyle>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qputenv("QSG_RHI_BACKEND", "opengl");

    app.setOrganizationName("CB4Tech");
    app.setOrganizationDomain("cb4tech.com");
    app.setApplicationName("CB4Terminal");

    qputenv("QML_DISABLE_DISK_CACHE", "true");

    QmlApp a;
#ifdef TESTING
#endif

    return app.exec();
}
