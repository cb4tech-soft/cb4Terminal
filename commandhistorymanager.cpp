#include "commandhistorymanager.h"

#include <QQmlApplicationEngine>
#include <QQmlEngine>

CommandHistoryManager *CommandHistoryManager::m_pThis = nullptr;

CommandHistoryManager::CommandHistoryManager(QObject *parent)
    : QObject(parent)
{}

void CommandHistoryManager::setCurrentPosition(int newCurrentPosition)
{
    currentPosition = newCurrentPosition;
}

void CommandHistoryManager::registerQml()
{
    qmlRegisterSingletonType<CommandHistoryManager>("CommandHistoryManager",
                                                    1,
                                                    0,
                                                    "CommandHistoryManager",
                                                    &CommandHistoryManager::qmlInstance);
}

CommandHistoryManager *CommandHistoryManager::instance()
{
    if (m_pThis == nullptr) // avoid creation of new instances
    {
        m_pThis = new CommandHistoryManager;
    }
    return m_pThis;
}

QObject *CommandHistoryManager::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    // C++ and QML instance they are the same instance
    return CommandHistoryManager::instance();
}

void CommandHistoryManager::appendCommand(QString command, bool syntaxMode)
{
    QPair<QString, bool> commandToAdd;
    commandToAdd.first = command;
    commandToAdd.second = syntaxMode;

    commandHistory.prepend(commandToAdd);

    if(commandHistory.count() > MAX_COMMAND_HISTORY) {
        for(int i = 0; i < commandHistory.count() - MAX_COMMAND_HISTORY; i++) {
            commandHistory.removeLast();
        }
    }
}

QVariantList CommandHistoryManager::getPreviousCommand()
{
    if(currentPosition < commandHistory.count() - 1) {
        currentPosition++;
    }

    QVariantList commandToReturn;
    commandToReturn.append(commandHistory[currentPosition].first);
    commandToReturn.append(commandHistory[currentPosition].second);

    return commandToReturn;
}

QVariantList CommandHistoryManager::getNextCommand()
{
    if(currentPosition > -1) {
        currentPosition--;
    }

    QVariantList commandToReturn;
    if(currentPosition == -1) {
        commandToReturn.append("");
        commandToReturn.append(SYNTAX_ASCII);
        return commandToReturn;
    }

    commandToReturn.append(commandHistory[currentPosition].first);
    commandToReturn.append(commandHistory[currentPosition].second);

    return commandToReturn;
}
