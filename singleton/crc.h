#ifndef CRC_H
#define CRC_H

#include <QObject>
#include <QQmlEngine>

class CRC : public QObject
{
    Q_OBJECT
public:
    static void registerQml();
    static CRC *instance();
    static QObject *qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine);

public slots:
    Q_INVOKABLE QByteArray fletcher16(const QByteArray &data);
    Q_INVOKABLE QByteArray crc16(const QByteArray &data);
    Q_INVOKABLE QByteArray xor8(const QByteArray &data);

signals:

private slots:


private:
    explicit CRC(QObject *parent = nullptr);
    static CRC *m_pThis;
};

#endif // CRC_H
