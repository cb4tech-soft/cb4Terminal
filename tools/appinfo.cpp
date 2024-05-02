#include "appinfo.h"

#include <QQmlApplicationEngine>
#include <QQmlEngine>

#ifdef APP_VERSION_NAME
const QString appVersionName(APP_VERSION_NAME);

#endif
#ifdef APP_VERSION_CODE
const QString appVersionCode(APP_VERSION_CODE);
#endif

const QString compilationDateTime(QDateTime::fromString(QStringLiteral(__DATE__) + QStringLiteral(" ") + QStringLiteral(__TIME__), "MMM  d yyyy hh:mm:ss").toString("MMddyy_hhmmss"));

AppInfo *AppInfo::m_pThis = nullptr;

AppInfo::AppInfo(QObject *parent)
    : QObject(parent)
{}

void AppInfo::registerQml()
{
    qmlRegisterSingletonType<AppInfo>("AppInfo", 1, 0, "AppInfo", &AppInfo::qmlInstance);
}

AppInfo *AppInfo::instance()
{
    if (m_pThis == nullptr) // avoid creation of new instances
    {
        m_pThis = new AppInfo;
    }
    return m_pThis;
}

QObject *AppInfo::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    // C++ and QML instance they are the same instance
    return AppInfo::instance();
}

QString AppInfo::getCompilationDateTime()
{
    return compilationDateTime;
}

QString AppInfo::getVersionName()
{
    qDebug() << "getVersionName" << appVersionName;
#ifdef APP_VERSION_NAME
    return appVersionName;
#else
    return "NOTDEFINED";
#endif
}

QString AppInfo::getVersionNumber()
{
#ifdef APP_VERSION_CODE
    return appVersionCode;
#else
    return "NOTDEFINED";
#endif
}
