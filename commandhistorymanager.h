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
        COMMAND_SYNTAX_MODE = 1,
        COMMAND_CRLF_MODE = 2
    };
    Q_ENUM(commandData_e)

    enum syntaxMode_e {
        SYNTAX_ASCII = false,
        SYNTAX_HEXA = true
    };
    Q_ENUM(syntaxMode_e)

    enum crlfMode_e {
        CRLF_MODE_NONE = 0,
        CRLF_MODE_N = 1,
        CRLF_MODE_R = 2,
        CRLF_MODE_RN = 3,
        CRLF_MODE_0 = 4
    };
    Q_ENUM(crlfMode_e)

    typedef struct serialCommand_s {
        QString commandString;
        syntaxMode_e syntaxMode;
        crlfMode_e clrfMode;
    } SerialCommand;

public slots:
    Q_INVOKABLE void appendCommand(QString command, bool syntaxMode, int crlfMode);

    Q_INVOKABLE QVariantList getPreviousCommand();
    Q_INVOKABLE QVariantList getNextCommand();

    Q_INVOKABLE void setCurrentPosition(int newCurrentPosition);

signals:

private slots:

private:
    explicit CommandHistoryManager(QObject *parent = nullptr);
    static CommandHistoryManager *m_pThis;

    QList<SerialCommand> commandHistory;
    int currentPosition = -1;

};

#endif // COMMANDHISTORYMANAGER_H
