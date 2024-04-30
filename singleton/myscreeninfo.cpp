

#include "myscreeninfo.h"
#include "qscreen.h"

#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QDebug>
#include <QGuiApplication>
#include <QScreen>
#include <QRect>

MyScreenInfo* MyScreenInfo::m_pThis = nullptr;

MyScreenInfo::MyScreenInfo(QObject *parent) : QObject(parent)
{
    qDebug()<< Q_FUNC_INFO ;

}

void MyScreenInfo::registerQml()
{
    qmlRegisterSingletonType<MyScreenInfo>("MyScreenInfo", 1, 0, "MyScreenInfo", &MyScreenInfo::qmlInstance);
}

MyScreenInfo *MyScreenInfo::instance()
{
    if (m_pThis == nullptr) // avoid creation of new instances
    {
        m_pThis = new MyScreenInfo;
    }
    return m_pThis;
}

QObject *MyScreenInfo::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    // C++ and QML instance they are the same instance
    return MyScreenInfo::instance();
}

QRect MyScreenInfo::getScreenInfo(int posX, int posY)
{
    QScreen *screen = QGuiApplication::screenAt(QPoint(posX, posY));

    return screen->geometry();
}
