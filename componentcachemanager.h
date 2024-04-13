#ifndef COMPONENTCACHEMANAGER_H
#define COMPONENTCACHEMANAGER_H

#include <QObject>
#include <QQmlEngine>

class ComponentCacheManager : public QObject
{
    Q_OBJECT

public:
    static void registerQml();
    static ComponentCacheManager *instance();
    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);

    Q_INVOKABLE void trim() { instance_engine->clearComponentCache(); }
    Q_INVOKABLE void createNewInstance();

    QQmlEngine *instance_engine = nullptr;

public slots:

signals:

private slots:

private:
    explicit ComponentCacheManager(QObject *parent = nullptr);
    static ComponentCacheManager *m_pThis;


};

#endif // COMPONENTCACHEMANAGER_H
