

#include "componentcachemanager.h"

#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QProcess>
#include <QGuiApplication>
#include <QClipboard>

ComponentCacheManager *ComponentCacheManager::m_pThis = nullptr;

ComponentCacheManager::ComponentCacheManager(QObject *parent)
    : QObject(parent)
{}

void ComponentCacheManager::registerQml()
{
    qmlRegisterSingletonType<ComponentCacheManager>("ComponentCacheManager",
                                                    1,
                                                    0,
                                                    "ComponentCacheManager",
                                                    &ComponentCacheManager::qmlInstance);
}

ComponentCacheManager *ComponentCacheManager::instance()
{
    if (m_pThis == nullptr) // avoid creation of new instances
    {
        m_pThis = new ComponentCacheManager;
    }
    return m_pThis;
}

QObject *ComponentCacheManager::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{

    Q_UNUSED(scriptEngine);
    // C++ and QML instance they are the same instance
    ComponentCacheManager *inst = ComponentCacheManager::instance();
    inst->instance_engine = engine;
    return inst;
}

void ComponentCacheManager::createNewInstance()
{
    QString programPath = QGuiApplication::applicationFilePath();
    qDebug() << "Starting new instance: " << programPath;
    QProcess::startDetached(programPath);
}

void ComponentCacheManager::copyToClipboard(QString text)
{
    QClipboard *clipboard = QGuiApplication::clipboard();
    clipboard->setText(text);
}

