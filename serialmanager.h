#ifndef SERIALMANAGER_H
#define SERIALMANAGER_H

#include <QObject>
#include <QSerialPort>
#include <QQmlEngine>
#include <QMetaType>
#include <QTimer>

#define BUFFERSIZE 255

class SerialInfo : public QObject
{
Q_OBJECT

public:
    explicit SerialInfo(QObject* parent = nullptr) : QObject(parent) {}
    Q_INVOKABLE QStringList getPortList();
    Q_INVOKABLE QString getInfo(QString com);


signals:


private:

};

extern SerialInfo serialInfo;

class SerialManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int baudrate READ baudrate WRITE setBaudrate NOTIFY baudrateChanged);
    Q_PROPERTY(int dataBits READ dataBits WRITE setDataBits NOTIFY dataBitsChanged);
    Q_PROPERTY(int flowControl READ flowControl WRITE setFlowControl NOTIFY flowControlChanged);
    Q_PROPERTY(int parity READ parity WRITE setParity NOTIFY parityChanged);
    Q_PROPERTY(int stopBits READ stopBits WRITE setStopBits NOTIFY stopBitsChanged);
    Q_PROPERTY(int isConnected READ isConnected WRITE setIsConnected NOTIFY isConnectedChanged);
    Q_PROPERTY(int receiveTimeout READ receiveTimeout WRITE setReceiveTimeout NOTIFY receiveTimeoutChanged);
    Q_ENUMS(QSerialPort::BaudRate);
    Q_ENUMS(QSerialPort::DataBits);
    Q_ENUMS(QSerialPort::FlowControl);
    Q_ENUMS(QSerialPort::Parity);
    Q_ENUMS(QSerialPort::StobBits);

public:
    explicit SerialManager(QObject *parent = nullptr);
    static void registerQml();

    Q_INVOKABLE void test();
    Q_INVOKABLE QStringList getComList();
    Q_INVOKABLE void connectToPort(QString portName);
    Q_INVOKABLE void disconnectFromPort();
    Q_INVOKABLE QString readAll();
    Q_INVOKABLE bool isLineAvailable();
    Q_INVOKABLE QString readLine();
    Q_INVOKABLE void sendData(QList<int> dataOut);
    Q_INVOKABLE void sendString(QString dataOut);
    Q_INVOKABLE void saveToFile(QStringList dataList, QString filepath, bool timestampsEnabled);

    Q_INVOKABLE QString getComInfo(QString com);



    static SerialInfo *getStaticInfoInstance();


    int baudrate() const;
    void setBaudrate(int newBaudrate);

    int dataBits() const;
    void setDataBits(int newDataBits);

    int flowControl() const;
    void setFlowControl(int newFlowControl);

    int parity() const;
    void setParity(int newParity);

    int stopBits() const;
    void setStopBits(int newStopBits);

    int isConnected() const;
    void setIsConnected(int newIsConnected);

    int receiveTimeout() const;
    void setReceiveTimeout(int newReceiveTimeout);

signals:
    void dataAvailable();
    void lineAvailable();

    void baudrateChanged();
    void dataBitsChanged();
    void flowControlChanged();
    void parityChanged();
    void stopBitsChanged();


    void isConnectedChanged();

    void receiveTimeoutChanged();

    void errorOccured(QString error);

private slots:
    void checkData();
    void errorHandler(QSerialPort::SerialPortError error);

private:
    QSerialPort *port = nullptr;
    SerialInfo *info;
    QTimer *timer;
    QString m_portName;

    int m_baudrate = 19200;
    int m_dataBits = 8;
    int m_flowControl = 0;
    int m_parity = 0;
    int m_stopBits = 0;
    int m_isConnected;
    int m_receiveTimeout = 100;
};



#endif // SERIALMANAGER_H
