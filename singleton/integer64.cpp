

#include "integer64.h"

#include <QQmlApplicationEngine>
#include <QQmlEngine>

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

    m_value = value;
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

QString UInteger64::value() const
{
    return m_value;
}

void UInteger64::setValue(QString value)
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
        m_value.append(0);
    }
    uint64_t valueInt = *((uint64_t*)m_value.toStdString().c_str());

    return QString::number(valueInt);
}

QDateTime UInteger64::toDate()
{
    while (m_value.length() < 8)
    {
        m_value.append(0);
    }
    uint64_t valueInt = *((uint64_t*)m_value.toStdString().c_str());
    QDateTime dt;
    dt.setMSecsSinceEpoch(valueInt);
    return dt;
}
