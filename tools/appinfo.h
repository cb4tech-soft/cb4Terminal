#ifndef APPINFO_H
#define APPINFO_H

#include <QObject>
#include <QQmlEngine>

class AppInfo : public QObject
{
    Q_OBJECT
public:
    static void registerQml();
    static AppInfo *instance();
    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);

public slots:
    Q_INVOKABLE QString getCompilationDateTime();
    Q_INVOKABLE QString getVersionName();
    Q_INVOKABLE QString getVersionNumber();

signals:
    void nameChanged();

private slots:

private:
    explicit AppInfo(QObject *parent = nullptr);
    static AppInfo *m_pThis;

};

#endif // APPINFO_H
