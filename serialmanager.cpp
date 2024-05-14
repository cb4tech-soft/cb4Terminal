#include "serialmanager.h"
#include <QColor>
#include <QQmlEngine>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QDebug>
//#include <QFileDialog>
#include <QStandardPaths>
#include <QFile>
SerialInfo serialInfo;


SerialManager::SerialManager(QObject *parent) : QObject(parent)
{
    setIsConnected(0);
    port = nullptr;
    timer = new QTimer(this);
    timer->setSingleShot(true);
    connect(timer, &QTimer::timeout, this, &SerialManager::dataAvailable);
}

void SerialManager::registerQml()
{
    qmlRegisterType<SerialManager>("SerialManager", 1, 0, "SerialManager");
    qmlRegisterSingletonInstance( "SerialInfo", 1, 0, "SerialInfo", getStaticInfoInstance());
}

QStringList SerialManager::getComList()
{
    QList<QSerialPortInfo> portList = QSerialPortInfo::availablePorts();
    QStringList result;
    foreach (const QSerialPortInfo &info, portList)
    {
        result.append(info.portName());
    }
    return result;
}

void SerialManager::test()
{
    emit dataAvailable();
}

void SerialManager::connectToPort(QString portName)
{
    if (port)
    {
        if (port->isOpen()) port->close();
        delete port;
        port = nullptr;
        setIsConnected(0);
    }
//    portName = "ttysWK2"; // ruggedTablet bruno (not detected)

    port = new QSerialPort(portName);
    m_portName = portName;
    qDebug()<< "connect to " << portName;
    connect(port, &QSerialPort::errorOccurred, this, &SerialManager::errorHandler);
    port->setBaudRate(m_baudrate);
    port->open(QIODevice::ReadWrite);
    if (port->isOpen())
    {
        qDebug()<< "port open " << portName;
        setIsConnected(1);
    }
    connect(port,SIGNAL(readyRead()), this, SLOT(checkData()));
}

void SerialManager::disconnectFromPort()
{
    if (port && port->isOpen())
    {
        port->close();
        delete port;
        port = nullptr;
        setIsConnected(0);
    }

}

bool SerialManager::isLineAvailable()
{
    if (port && port->canReadLine())
        return true;
    return false;

}

void SerialManager::checkData()
{
    qDebug() << "CheckData !";
    if (port->canReadLine())
        emit lineAvailable();
    //emit dataAvailable();
    else if(port->bytesAvailable()) {
        if(port->bytesAvailable() > BUFFERSIZE) {
            emit dataAvailable();
       } else {
            timer->start(100);
        }
    }
}

void SerialManager::errorHandler(QSerialPort::SerialPortError error)
{
    switch (error)
    {
    case QSerialPort::SerialPortError::DeviceNotFoundError:
        setIsConnected(0);
        qDebug() << " => Device Not Found";
    break;
    case QSerialPort::SerialPortError::OpenError:
        setIsConnected(0);
        qDebug() << " => Open Error";
    break;
    case QSerialPort::SerialPortError::NotOpenError:
        setIsConnected(0);
        qDebug() << " => Device Not Open";
    break;
    case QSerialPort::SerialPortError::WriteError:
        setIsConnected(0);
        qDebug() << " => Device Write Error";
    break;
    case QSerialPort::SerialPortError::ReadError:
        setIsConnected(0);
        qDebug() << " => Device Read Error";
    break;
    case QSerialPort::SerialPortError::TimeoutError:
        setIsConnected(0);
        qDebug() << " => Device Timeout";
    break;
    case QSerialPort::SerialPortError::ResourceError:
        qDebug() << " => ressource error";
        setIsConnected(0);
        QTimer::singleShot(2000, [=]{this->connectToPort(m_portName);});

    break;
    default:
        setIsConnected(0);
        qDebug() << " => State : " << error;
    break;
    }
}

QString SerialManager::readLine()
{
    if (Q_LIKELY(port != nullptr))
    {
        QString dataString = QString::fromUtf8(port->readLine());
        if(port->bytesAvailable())
        {
            timer->start(100);
        }
        else
            timer->stop();
        return dataString;
    }
    else
        return "port close";
}

QString SerialManager::readAll()
{
    if (Q_LIKELY(port != nullptr))
    {
        QString dataString = QString::fromLatin1(port->readAll());
        if(port->bytesAvailable())
        {
            timer->start(100);
        }
        else
            timer->stop();
        return dataString;
    }
    else
        return "port close";
}

void SerialManager::sendData(QList<int> dataOut)
{
    QByteArray arrayToSend;
    if (port && port->isOpen())
    {
        while (dataOut.length())
        {
            arrayToSend.append(dataOut.takeFirst());
        }
        port->write(arrayToSend);
    }
}

void SerialManager::sendString(QString dataOut)
{
    if (port && port->isOpen())
    {
        port->write(dataOut.toLocal8Bit());
    }
}

void SerialManager::saveToFile(QStringList dataList, QString filepath, bool timestampsEnabled)
{
    //qDebug() << dataList;
    /*QString caption = "Select destination";
    QString defaultPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString filter = tr("All files (*.*)");
    //QFileDialog(this, caption, defaultPath, filter);
    QFileDialog *file = new QFileDialog();
    file->setDirectory(defaultPath);
    file->setWindowTitle(caption);
    file->show();*/
    //QFileDialog::getExistingDirectory();
    QString stringLog = "";
    filepath.remove(0, 7);
    if(timestampsEnabled) {
        for(int i = 0; i < dataList.size(); i++) {
            stringLog.append(dataList[i]);
            if(i % 2 != 0)
                stringLog.append("\n");
        }
    } else {
        for(int i = 0; i < dataList.size(); i++) {
            stringLog.append(dataList[i]);
            stringLog.append("\n");
        }
    }
    QFile *file = new QFile();
    int count = 0;
    bool notExist = false;
    while(!notExist) {
        QString path = filepath + "/termLog" + QString::number(count) + ".txt";
        file->setFileName(path);
        if(file->exists()) {
            count++;
        } else {
            notExist = true;
        }
    }
    if (file->open(QIODevice::WriteOnly | QIODevice::Text)) {
        QTextStream fileIn(file);
        fileIn << stringLog;
        file->close();
    } else {
       qDebug("File opening problem.");
       qDebug() << file->fileName();
    }
}

SerialInfo *SerialManager::getStaticInfoInstance()
{
    return &serialInfo;
}


int SerialManager::baudrate() const
{
    return m_baudrate;
}

void SerialManager::setBaudrate(int newBaudrate)
{
    if (m_baudrate == newBaudrate)
        return;
    m_baudrate = newBaudrate;
    if (port && port->isOpen())
    {
        qDebug() << "Change baudrate for " << port->portName();
        port->setBaudRate(newBaudrate);
    }
    emit baudrateChanged();
}

int SerialManager::dataBits() const
{
    return m_dataBits;
}

void SerialManager::setDataBits(int newDataBits)
{
    if (m_dataBits == newDataBits)
        return;
    m_dataBits = newDataBits;
    if (port && port->isOpen())
    {
        qDebug() << "Change data bits for " << port->portName();
       switch(newDataBits) {
            case 5:
                port->setDataBits(QSerialPort::Data5);
                break;
            case 6:
                port->setDataBits(QSerialPort::Data6);
                break;
            case 7:
                port->setDataBits(QSerialPort::Data7);
                break;
            case 8:
                port->setDataBits(QSerialPort::Data8);
                break;
       };
    }
    emit dataBitsChanged();
}

int SerialManager::flowControl() const
{
    return m_flowControl;
}

void SerialManager::setFlowControl(int newFlowControl)
{
    if (m_flowControl == newFlowControl)
        return;
    m_flowControl = newFlowControl;
    if (port && port->isOpen())
    {
        qDebug() << "Change flow control for " << port->portName();
        switch(newFlowControl) {
            case 0:
                port->setFlowControl(QSerialPort::NoFlowControl);
                break;
            case 1:
                port->setFlowControl(QSerialPort::HardwareControl);
                break;
            case 2:
                port->setFlowControl(QSerialPort::SoftwareControl);
                break;
        };
    }
    emit flowControlChanged();
}

int SerialManager::parity() const
{
    return m_parity;
}

void SerialManager::setParity(int newParity)
{
    if (m_parity == newParity)
        return;
    m_parity = newParity;
    if (port && port->isOpen())
    {
        qDebug() << "Change parity for " << port->portName();
        switch(newParity) {
            case 0:
                port->setParity(QSerialPort::NoParity);
                break;
            case 1:
                port->setParity(QSerialPort::EvenParity);
                break;
            case 2:
                port->setParity(QSerialPort::OddParity);
                break;
            case 3:
                port->setParity(QSerialPort::SpaceParity);
                break;
            case 4:
                port->setParity(QSerialPort::MarkParity);
                break;

        };
    }
    emit parityChanged();
}

int SerialManager::stopBits() const
{
    return m_stopBits;
}

void SerialManager::setStopBits(int newStopBits)
{
    if (m_stopBits == newStopBits)
        return;
    m_stopBits = newStopBits;
    if (port && port->isOpen())
    {
        qDebug() << "Change parity for " << port->portName();
        switch(newStopBits) {
            case 0:
                port->setStopBits(QSerialPort::OneStop);
                break;
            case 1:
                port->setStopBits(QSerialPort::OneAndHalfStop);
                break;
            case 2:
                port->setStopBits(QSerialPort::TwoStop);
                break;
        };
    }
    emit stopBitsChanged();
}

QStringList SerialInfo::getPortList()
{
    QList<QSerialPortInfo> portList = QSerialPortInfo::availablePorts();
    QStringList result;
    foreach (const QSerialPortInfo &info, portList)
    {

        result.append(info.portName());

    }
    return result;
}

QString SerialInfo::getInfo(QString com)
{
    QSerialPortInfo info(com);
    QString result;
    result = "name : " + com + "\n";
    result += "description : " + info.description() + "\n";
    result += "vendor : " + QString::number(info.vendorIdentifier()) + " product : " + QString::number(info.productIdentifier());
    //= info.description();
    result += "\n";
    return result;
}

 int SerialManager::isConnected() const
 {
     return m_isConnected;
 }

 void SerialManager::setIsConnected(int newIsConnected)
 {
     if (m_isConnected == newIsConnected)
         return;
     m_isConnected = newIsConnected;
     emit isConnectedChanged();
 }
