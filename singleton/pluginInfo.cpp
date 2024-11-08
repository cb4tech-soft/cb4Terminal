

#include "pluginInfo.h"
#include "tools/debug_info.h"

#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QDir>
#include <QFileSystemWatcher>
#include <QFile>
#include <QTimer>
#include <QDirIterator>
#include "tools/appinfo.h"

#ifdef Q_OS_WINDOWS
extern Q_CORE_EXPORT int qt_ntfs_permission_lookup;
#endif
PluginInfo* PluginInfo::m_pThis = nullptr;

PluginInfo::PluginInfo(QObject *parent) : QObject(parent)
{
#ifdef Q_OS_WINDOWS
    QNtfsPermissionCheckGuard permissionGuard;
#endif
    QDir d(pluginFolder);
    if (!d.exists())
    {
        d.mkpath(d.absolutePath());
        qDebug()<<"plugin folder created" << pluginFolder;
    }
#if (BUILD_PLUGIN_TESTUNIT == 1)
    testUnitPlugin_fileWatcher();
#endif
    extractQrcPlugin();
    updatePluginList();
    watcher.addPath(pluginFolder);
    connect(&watcher, &QFileSystemWatcher::directoryChanged, this, &PluginInfo::updatePluginList);
    compilationDateTime = AppInfo::instance()->getCompilationDateTime();
}

// extract qml plugins from plugins.qrc to plugin folder
void PluginInfo::extractQrcPlugin()
{
#ifndef Q_OS_ANDROID
    QNtfsPermissionCheckGuard permissionGuard;
#endif
    QDir d(pluginFolder);
    QFile versionFile(pluginFolder + BUILD_VERSION_FILE);
    bool newVersion = false;
    if (!d.exists())
    {

        d.mkpath(d.absolutePath());
        versionFile.open(QIODevice::WriteOnly);
        versionFile.write(compilationDateTime.toLatin1());
        versionFile.close();
        qDebug()<<"plugin folder created" << pluginFolder;
    }
    else
    {
        if (!versionFile.open(QIODevice::ReadOnly))
        {
            qDebug()<< "create file version.txt" << QStringLiteral(__DATE__);
            versionFile.open(QIODevice::ReadWrite);
            versionFile.write(compilationDateTime.toLatin1());
            versionFile.close();
        }

        QByteArray version = versionFile.readAll();
        versionFile.close();
        if (version != compilationDateTime.toLatin1())
        {
            qDebug()<<"new version of plugin";
            newVersion = true;
            versionFile.open(QIODevice::WriteOnly);
            versionFile.write(compilationDateTime.toLatin1());
            versionFile.close();
        }
    }
    QDirIterator it(":/plugin/", QDirIterator::Subdirectories);
    while (it.hasNext())
    {
        QString path = it.next();
        qDebug()<<"extractQrcPlugin: "<<path;
        QFileInfo fileInfo(path);
        if (fileInfo.isFile())
        {
            QDBG_GREEN() << "file: " << path << DBG_CLR_RESET;
            QString saveFolderPath = QString(path).replace(":/plugin/", pluginFolder, Qt::CaseInsensitive);

            QDBG_GREEN() << "new path file: " << saveFolderPath << DBG_CLR_RESET;
            if (QFile::exists(saveFolderPath))
            {
                QFile f(saveFolderPath);
                QString filePath = QFileInfo(f).absoluteFilePath();
                if (newVersion)
                {
                    f.setPermissions((QFileDevice::Permission)0x7777);

                    /*
                    qDebug()<<"remove old version of plugin: " <<  fileInfo.fileName();
                    qDebug()<<" remove result" << f.remove();
                    */
                }
                else
                {
                    continue;
                }
            }
            qDebug() << "copy file" << path << "to" << saveFolderPath << QFile::copy(path, saveFolderPath);

        }
        else if (fileInfo.isDir())
        {
            QDir dir(pluginFolder + fileInfo.fileName());
            QDBG_GREEN() << "dir: " << pluginFolder + fileInfo.fileName() << DBG_CLR_RESET;
            /*
            if (dir.exists())
            {
                dir.remove(pluginFolder + fileInfo.fileName());
            }
            */
            dir.mkpath(dir.absolutePath());
        }
    }


}



#if (BUILD_PLUGIN_TESTUNIT == 1)
void PluginInfo::testUnitPlugin_fileWatcher()
{
    QTimer::singleShot(1000, [=]{
        qDebug("\033[32m"); // switch debug to green color
        qWarning() << "\ttestUnitPlugin_fileWatcher";
        qWarning() << "Creation d'un fichier test.qml";
        QFile file(pluginFolder + "test.qml");
        QFileInfo fileInfo(file);
        file.open(QIODevice::WriteOnly);
        file.write("Hello world");
        file.close();
        qWarning() << "Creation d'un fichier test.txt";
        QFile file2(pluginFolder + "test.txt");
        file2.open(QIODevice::WriteOnly);
        file2.write("Hello world");
        file2.close();
        QTimer::singleShot(50, [=]{qDebug("\033[0m");});

        QTimer::singleShot(1000, [=]{
            qDebug("\033[32m"); // switch debug to green color
            qWarning() << "Suppression du fichier test.qml";
            QFile file(pluginFolder + "test.qml");
            file.remove();
            QTimer::singleShot(50, [=]{qDebug("\033[0m");});

        });

        QTimer::singleShot(1500, [=]{
            qDebug("\033[32m"); // switch debug to green color
            qWarning() << "Suppression du fichier test.txt";

            QFile file(pluginFolder + "test.txt");
            file.remove();
            QTimer::singleShot(50, [=]{qDebug("Fin du test\033[0m");});

        });
    });
}
#endif


void PluginInfo::updatePluginList()
{
    QDBG_FUNCNAME_BLUE("[PLUGINS] >>");
    QDir d(pluginFolder);
    QStringList dirs = d.entryList(QDir::Dirs);
    QStringList fullPathList;
    for (const QString &dirPath: dirs)
    {
        if (dirPath == "." || dirPath == "..")
            continue;
        QString filePath = pluginFolder + dirPath + "/" + dirPath + ".qml";
        QFile plugin(filePath);
        if (plugin.exists())
        {
//            QDBG_BLUE() << filePath << DBG_CLR_RESET;
            fullPathList.append(d.absoluteFilePath(dirPath + "/" + dirPath + ".qml"));
        }
        else{
            QDBG_RED() << "ERROR " << filePath  << " plugin main file not found " << DBG_CLR_RESET;
        }
    }

    // compare 2 lists and print difference
    for (const QString &file : fullPathList)
    {
        if (m_pluginFiles.contains(file))
            continue;
        QDBG_BLUE()<<"new plugin file: "<<file << DBG_CLR_RESET;
    }

    setPluginFiles(fullPathList);

}

void PluginInfo::registerQml()
{
    qmlRegisterSingletonType<PluginInfo>("PluginInfo", 1, 0, "PluginInfo", &PluginInfo::qmlInstance);
}

PluginInfo *PluginInfo::instance()
{
    if (m_pThis == nullptr) // avoid creation of new instances
    {
        m_pThis = new PluginInfo;
    }
    return m_pThis;
}

QObject *PluginInfo::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine) {
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    // C++ and QML instance they are the same instance
    return PluginInfo::instance();
}

QStringList PluginInfo::pluginFiles() const
{
    return m_pluginFiles;
}

void PluginInfo::setPluginFiles(const QStringList &newPluginFiles)
{
    if (m_pluginFiles == newPluginFiles)
        return;
    m_pluginFiles = newPluginFiles;
    emit pluginFilesChanged();
}
