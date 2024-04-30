#ifndef MYSCREENINFO_H
#define MYSCREENINFO_H

#include <QObject>
#include <QQmlEngine>
#include <QRect>
class MyScreenInfo : public QObject
{
    Q_OBJECT

public:
    static void registerQml();
    static MyScreenInfo *instance();
    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);


public slots:
    Q_INVOKABLE QRect getScreenInfo(int posX, int posY);

signals:
    void nameChanged();

private slots:

private:
    explicit MyScreenInfo(QObject *parent = nullptr);
    static MyScreenInfo* m_pThis;

};

#endif // MYSCREENINFO_H
