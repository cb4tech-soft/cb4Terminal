#ifndef FILEUTILS_H
#define FILEUTILS_H

#include <QObject>
#include <QQmlEngine>

class FileUtils : public QObject
{
    Q_OBJECT
public:
    static void registerQml();
    static FileUtils *instance();
    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);

    Q_INVOKABLE QStringList getDiskList();

    Q_INVOKABLE QStringList getFileInfo(QString filePath);
    Q_INVOKABLE QStringList getDriveInfo(QString dirPath);

    Q_INVOKABLE bool copyFileToDest(QString file, QString destination);
public slots:

signals:

private slots:

private:
    explicit FileUtils(QObject *parent = nullptr);
    static FileUtils *m_pThis;

};

#endif // FILEUTILS_H
