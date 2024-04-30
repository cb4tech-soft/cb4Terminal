

#include "softwarelauncher.h"

#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QProcess>

SoftwareLauncher* SoftwareLauncher::m_pThis = nullptr;

SoftwareLauncher::SoftwareLauncher(QObject *parent) : QObject(parent)
{

}

void SoftwareLauncher::registerQml()
{
    qmlRegisterSingletonType<SoftwareLauncher>("SoftwareLauncher", 1, 0, "SoftwareLauncher", &SoftwareLauncher::qmlInstance);
}

SoftwareLauncher *SoftwareLauncher::instance()
{
    if (m_pThis == nullptr) // avoid creation of new instances
    {
        m_pThis = new SoftwareLauncher;
    }
    return m_pThis;
}

QObject *SoftwareLauncher::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    // C++ and QML instance they are the same instance
    return SoftwareLauncher::instance();
}

void SoftwareLauncher::launchSoftware(QString softwarePath, QStringList softwareArgs)
{
    QProcess::startDetached(softwarePath, softwareArgs);
}

