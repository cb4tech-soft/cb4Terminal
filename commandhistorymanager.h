#ifndef COMMANDHISTORYMANAGER_H
#define COMMANDHISTORYMANAGER_H

#include <QObject>
#include <QQmlEngine>

#define MAX_COMMAND_HISTORY 200

class CommandHistoryManager : public QObject
{
    Q_OBJECT
public:
    static void registerQml();
    static CommandHistoryManager *instance();
    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);

    enum commandData_e {
        COMMAND_STRING = 0,
        COMMAND_SYNTAX_MODE = 1
    };
    Q_ENUM(commandData_e)

    enum syntaxMode_e {
        SYNTAX_ASCII = false,
        SYNTAX_HEXA = true
    };
    Q_ENUM(syntaxMode_e)

public slots:
    Q_INVOKABLE void appendCommand(QString command, bool syntaxMode);

signals:

private slots:

private:
    explicit CommandHistoryManager(QObject *parent = nullptr);
    static CommandHistoryManager *m_pThis;

    QList<QPair<QString, bool>> commandHistory;
    int currentPosition = 0;

};

#endif // COMMANDHISTORYMANAGER_H
