#ifndef SOFTWARELAUNCHER_H
#define SOFTWARELAUNCHER_H

#include <QObject>
#include <QQmlEngine>

class SoftwareLauncher : public QObject
{
    Q_OBJECT
public:
    static void registerQml();
    static SoftwareLauncher *instance();
    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);

    Q_INVOKABLE void launchSoftware(QString softwarePath, QStringList softwareArgs = QStringList());

public slots:

signals:

private slots:


private:
    explicit SoftwareLauncher(QObject *parent = nullptr);
    static SoftwareLauncher* m_pThis;

};

#endif // SOFTWARELAUNCHER_H
