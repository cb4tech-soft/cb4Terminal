#ifndef COMPONENTCACHEMANAGER_H
#define COMPONENTCACHEMANAGER_H

#include <QObject>
#include <QQmlEngine>

#define SPECIAL_MODE_LOG_COPY "logCopy"

class ComponentCacheManager : public QObject
{
    Q_OBJECT

public:
    static void registerQml();
    static ComponentCacheManager *instance();
    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);

    Q_INVOKABLE void trim() { instance_engine->clearComponentCache(); }
    Q_INVOKABLE void createNewInstance();

    Q_INVOKABLE void createLogCopyView(QString text);
    Q_INVOKABLE void loadLogCopyview(QString text);

    Q_INVOKABLE void copyToClipboard(QString text);

    QQmlEngine *instance_engine = nullptr;

public slots:

signals:
    void logCopyText(QString text);

private slots:

private:
    explicit ComponentCacheManager(QObject *parent = nullptr);
    static ComponentCacheManager *m_pThis;


};

#endif // COMPONENTCACHEMANAGER_H
