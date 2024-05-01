

#include "fileutils.h"

#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QFileInfo>
#include <QStorageInfo>
#include <QDir>

FileUtils *FileUtils::m_pThis = nullptr;

FileUtils::FileUtils(QObject *parent)
    : QObject(parent)
{}

void FileUtils::registerQml()
{
    qmlRegisterSingletonType<FileUtils>("FileUtils", 1, 0, "FileUtils", &FileUtils::qmlInstance);
}

FileUtils *FileUtils::instance()
{
    if (m_pThis == nullptr) // avoid creation of new instances
    {
        m_pThis = new FileUtils;
    }
    return m_pThis;
}

QObject *FileUtils::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    // C++ and QML are the same instance
    return FileUtils::instance();
}

QStringList FileUtils::getDiskList()
{
    QStringList drives;
    foreach(QFileInfo info, QDir::drives())
    {
        drives.append(info.absoluteFilePath());
    }
    return drives;
}

QStringList FileUtils::getFileInfo(QString dirPath)
{
    QFileInfo info(dirPath);
    QStringList result;
    result.append(info.absoluteFilePath());
    QString type = "TYPE : ";
    if (info.isDir())
    {
        type.append("Dir");
    }
    else if (info.isExecutable())
    {
        type.append("Executable");
    }
    else if (info.isFile())
    {
        type.append("File");
    }
    else if (info.isSymLink())
    {
        type.append("SymLink");
    }
    else
    {
        type.append("Unknown");
    }
    result.append(type);
    result.append("SIZE : " + QString::number(info.size()));
    result.append("LAST MODIFIED : " + info.lastModified().toString());
    return result;

}

QStringList FileUtils::getDriveInfo(QString dirPath)
{
    QStorageInfo storageInfo(dirPath);
    QStringList result;
    result.append(storageInfo.rootPath());
    result.append(storageInfo.displayName());
    result.append(storageInfo.fileSystemType());
    QString sizeString = "";
    if (storageInfo.bytesAvailable() > 1024 * 1024 * 1024)
        sizeString.append(QString::number(storageInfo.bytesAvailable() / (1024 * 1024 * 1024)) + " GB");
    else if (storageInfo.bytesAvailable() > 1024 * 1024)
        sizeString.append(QString::number(storageInfo.bytesAvailable() / (1024 * 1024)) + " MB");
    else if (storageInfo.bytesAvailable() > 1024)
        sizeString.append(QString::number(storageInfo.bytesAvailable() / 1024) + " KB");
    else
        sizeString.append(QString::number(storageInfo.bytesAvailable()) + " B");

    sizeString.append(" / ");
    if (storageInfo.bytesTotal() > 1024 * 1024 * 1024)
        sizeString.append(QString::number(storageInfo.bytesTotal() / (1024 * 1024 * 1024)) + " GB");
    else if (storageInfo.bytesTotal() > 1024 * 1024)
        sizeString.append(QString::number(storageInfo.bytesTotal() / (1024 * 1024)) + " MB");
    else if (storageInfo.bytesTotal() > 1024)
        sizeString.append(QString::number(storageInfo.bytesTotal() / 1024) + " KB");
    else
        sizeString.append(QString::number(storageInfo.bytesTotal()) + " B");

    result.append(sizeString);
    return result;
}

bool FileUtils::copyFileToDest(QString file, QString destination)
{
    /* transforme file to remove the file:// prefix */
    if (file.startsWith("file:///"))
    {
        file = file.mid(8);
    }
    QString destFileName = destination + "/" + QFileInfo(file).fileName();
    qDebug() << "Copying " << file << " to " << destFileName;
    return QFile::copy(file, destFileName);
}




