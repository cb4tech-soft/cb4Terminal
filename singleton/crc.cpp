

#include "crc.h"

#include <QQmlApplicationEngine>
#include <QQmlEngine>

CRC *CRC::m_pThis = nullptr;

CRC::CRC(QObject *parent)
    : QObject(parent)
{}

void CRC::registerQml()
{
    qmlRegisterSingletonType<CRC>("CRC", 1, 0, "CRC", &CRC::qmlInstance);
}

CRC *CRC::instance()
{
    if (m_pThis == nullptr) // avoid creation of new instances
    {
        m_pThis = new CRC;
    }
    return m_pThis;
}

QObject *CRC::qmlInstance(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine);
    Q_UNUSED(scriptEngine);
    // C++ and QML instance they are the same instance
    return CRC::instance();
}

QByteArray CRC::fletcher16(const QByteArray &data)
{
    uint8_t sum1 = 0;
    uint8_t sum2 = 0;
    for (int i = 0; i < data.size(); i++)
    {
        sum1 = (sum1 + (uint8_t)data.at(i));
        sum2 = (sum2 + sum1);
    }
    QByteArray result;
    result.append(sum1);
    result.append(sum2);
    return result;
}

QByteArray CRC::crc16(const QByteArray &data)
{
    quint16 crc = 0xFFFF;
    for (int i = 0; i < data.size(); i++)
    {
        crc ^= (quint8)data.at(i);
        for (int j = 0; j < 8; j++)
        {
            if (crc & 0x0001)
            {
                crc >>= 1;
                crc ^= 0xA001;
            }
            else
            {
                crc >>= 1;
            }
        }
    }
    QByteArray result;
    result.append(crc & 0xFF);
    result.append(crc >> 8);
    return result;
}

QByteArray CRC::xor8(const QByteArray &data)
{
    quint8 xorResult = 0;
    for (int i = 0; i < data.size(); i++)
    {
        xorResult ^= (quint8)data.at(i);
    }
    QByteArray result;
    result.append(xorResult);
    return result;
}
