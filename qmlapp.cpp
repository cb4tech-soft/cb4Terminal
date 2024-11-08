
#include <QDebug>
#include <QGuiApplication>

#include <QtQml/QQmlContext>
#include <QQuickStyle>
#include <QQmlApplicationEngine>

#include "qmlapp.h"

#include "viewpage/viewpage.h"
#include "serialmanager.h"
#include "singleton/pluginInfo.h"
#include "singleton/myscreeninfo.h"
#include "tools/debug_info.h"
#include "tools/appinfo.h"
#include "singleton/softwarelauncher.h"
#include "singleton/componentcachemanager.h"
#include "singleton/fileutils.h"
#include "singleton/integer64.h"
#include "singleton/crc.h"

#include "commandhistorymanager.h"

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
    PluginInfo::registerQml();
    ComponentCacheManager::registerQml();
    AppInfo::registerQml();
    SoftwareLauncher::registerQml();
    FileUtils::registerQml();
    Integer64::registerQml();
    CRC::registerQml();
    CommandHistoryManager::registerQml();


//    parent->setTitle(AppInfo::instance()->getVersionName());
//    QDBG_YELLOW() << QGuiApplication::arguments();
    load(QUrl("qrc:/qml/main.qml"));
    QDBG_YELLOW() << AppInfo::instance()->getCompilationDateTime() << DBG_CLR_RESET;
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
