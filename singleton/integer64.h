#ifndef INTEGER64_H
#define INTEGER64_H

#include <QObject>
#include <QQmlEngine>
#include <QDateTime>

class Integer64 : public QObject
{
    Q_OBJECT
public:
    explicit Integer64(QObject *parent = nullptr);
    static void registerQml();
    Q_PROPERTY(QString value READ value WRITE setValue NOTIFY valueChanged)
    QString value() const;
    void setValue(QString value);

    Q_INVOKABLE QString toString();
    Q_INVOKABLE QDateTime toDate();

public slots:

signals:
    void valueChanged(QString value);

private slots:

private:
    QString m_value;
};

#endif // INTEGER64_H
