

#include "integer64.h"
#include "qendian.h"

#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QByteArray>
#include <QDateTime>
#include <QDebug>
#include <QString>

Integer64::Integer64(QObject *parent)
    : QObject(parent)
{}

UInteger64::UInteger64(QObject *parent)
    : QObject(parent)
{}

void Integer64::registerQml()
{
    qmlRegisterType<Integer64>("Integer64", 1, 0, "Integer64");
}

void UInteger64::registerQml()
{
    qmlRegisterType<UInteger64>("UInteger64", 1, 0, "UInteger64");
}

QString Integer64::value() const
{
    return m_value;
}

void Integer64::setValue(QString value)
{
    if (m_value == value)
        return;

    m_value = value.toLatin1();
    emit valueChanged(m_value);
}

QString Integer64::toString()
{
    while (m_value.length() < 8)
    {
        m_value.append(0);
    }
    int64_t valueInt = *((int64_t*)m_value.toStdString().c_str());
    return QString::number(valueInt);
}

QDateTime Integer64::toDate()
{
    while (m_value.length() < 8)
    {
        m_value.append(0);
    }
    int64_t valueInt = *((int64_t*)m_value.toStdString().c_str());
    QDateTime dt;
    dt.setMSecsSinceEpoch(valueInt);
    return dt;
}

QByteArray UInteger64::value() const
{
    return m_value;
}

void UInteger64::setValue(QByteArray value)
{
    if (m_value == value)
        return;

    m_value = value;
    emit valueChanged(m_value);
}

QString UInteger64::toString()
{
    while (m_value.length() < 8)
    {
        m_value.append('\0');
    }
    uint64_t valueInt = *((uint64_t*)m_value.toStdString().c_str());

    return QString::number(valueInt);
}

QDateTime UInteger64::toDate(enum BYTE_ORDER byteOrder)
{
    while (m_value.length() < 8)
    {
        m_value.append('\0');
    }
    QDateTime dt = QDateTime();
    if (byteOrder == MSB_FIRST)
    {
        uint8_t dateReverse[8];
        int i = 0;
        while (i < 8)
        {
            dateReverse[i] = m_value.toStdString().c_str()[7-i];
            i++;
        }
        uint64_t valueInt = *((uint64_t*)dateReverse);
        dt.setSecsSinceEpoch(valueInt);
    }
    else
    {
        uint64_t valueInt = (uint64_t((uint8_t)m_value.toStdString().c_str()[0]))
                | (uint64_t((uint8_t)m_value.toStdString().c_str()[1]) << 8)
                | (uint64_t((uint8_t)m_value.toStdString().c_str()[2]) << 16)
                | (uint64_t((uint8_t)m_value.toStdString().c_str()[3]) << 24)
                | (uint64_t((uint8_t)m_value.toStdString().c_str()[4]) << 32)
                | (uint64_t((uint8_t)m_value.toStdString().c_str()[5]) << 40)
                | (uint64_t((uint8_t)m_value.toStdString().c_str()[6]) << 48)
                | (uint64_t((uint8_t)m_value.toStdString().c_str()[7]) << 56);
        dt.setSecsSinceEpoch(valueInt);
    }
    return dt;
}
