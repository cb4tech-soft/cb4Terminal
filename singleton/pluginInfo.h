#ifndef PLUGININFO_H
#define PLUGININFO_H

#include <QObject>
#include <QQmlEngine>
#include <QFileSystemWatcher>


#define BUILD_PLUGIN_TESTUNIT 0
#define BUILD_VERSION_FILE "version.txt"
class PluginInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList pluginFiles READ pluginFiles WRITE setPluginFiles NOTIFY pluginFilesChanged)
public:
    static void registerQml();
    static PluginInfo *instance();
    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);

    QStringList pluginFiles() const;
    void setPluginFiles(const QStringList &newPluginFiles);

public slots:

signals:

    void pluginFilesChanged();

private slots:
    void updatePluginList();


private:
    explicit PluginInfo(QObject *parent = nullptr);
    void extractQrcPlugin();

    static PluginInfo* m_pThis;
    QFileSystemWatcher watcher;

#if (BUILD_PLUGIN_TESTUNIT == 1)
    void testUnitPlugin_fileWatcher();
#endif
    const QString compdt = QDateTime::fromString(QStringLiteral(__DATE__) + QStringLiteral(" ") + QStringLiteral(__TIME__), "MMM  d yyyy hh:mm:ss").toString("MMddyy_hhmmss");//.arg().arg(__TIME__);

    QString pluginFolder = "./plugin/";
    QString compilationDateTime;
    QStringList m_pluginFiles;
};

#endif // PLUGININFO_H
