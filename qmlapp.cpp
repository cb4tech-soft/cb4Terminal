
#include <QDebug>

#include <QtQml/QQmlContext>
#include <QQuickStyle>
#include <QQmlApplicationEngine>

#include "qmlapp.h"

#include "viewpage/viewpage.h"
#include "serialmanager.h"
#include "pluginInfo.h"
#include "qml/myscreeninfo.h"
#include "qml/heatmapdata.h"
#include "cb4tools/build_info.h"
#include "cb4tools/debug_info.h"
#include "componentcachemanager.h"
#ifdef Q_OS_WIN



#endif


QmlApp::QmlApp(QWindow *parent) : QQmlApplicationEngine(parent)
{
    timer = new QTimer();
    timer->setInterval(5000);
    timer->start();

    QQuickStyle::setStyle("Material");

    SerialManager::registerQml();
    MyScreenInfo::registerQml();
    HeatMapData::registerQml();
    PluginInfo::registerQml();
    ComponentCacheManager::registerQml();

    load(QUrl("qrc:/qml/main.qml"));
    QDBG_YELLOW() << compilationDateTime << DBG_CLR_RESET;
}


void    QmlApp::viewChanger(ViewPage *page)
{
    if (m_page && page != m_page)
        m_page->deleteLater();
    m_page = page;
    page->show();
}

/*
 * Gestion Close Event
 */
bool QmlApp::event(QEvent *event)
{
    if (event->type() == QEvent::Close)
    {
        // return true to cancel close event
    }
    return QQmlApplicationEngine::event(event);
}

QmlApp::~QmlApp()
{

}
