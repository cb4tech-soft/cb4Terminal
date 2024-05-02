import QtQuick 2.0
import SerialInfo 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.11

import "../Style"
import SerialManager 1.0
import QtCore


Item {
    id: serialConfig
    width: 200
    height: 400
    clip: true
    signal connectClicked;

    property alias connectButton: connectButton
    property alias baudrateCB: baudRateList

    property int baudrate: baudRateList.currentValue
    property int dataBits: dataBitsList.currentValue
    property int flowControl: flowControlList.currentIndex
    property int parity: parityList.currentIndex
    property int stopBits: stopBitsList.currentIndex
    Settings {
        //property alias comListIndex: comList.port.currentIndex
        property alias baudrateIndex: baudRateList.currentIndex
        property alias dataBitsIndex: dataBitsList.currentIndex
        property alias flowControlIndex: flowControlList.currentIndex
        property alias parityIndex: parityList.currentIndex
        property alias stopBitsIndex: stopBitsList.currentIndex
    }

    onBaudrateChanged: {
        if (serialConfig.manager.isConnected)
            serialConfig.manager.baudrate = serialConfig.baudrate
    }

    onDataBitsChanged: {
        if(serialConfig.manager.isConnected)
            serialConfig.manager.dataBits = serialConfig.dataBits
    }

    onFlowControlChanged:{
        if(serialConfig.manager.isConnected)
            serialConfig.manager.flowControl = serialConfig.flowControl
    }

    onParityChanged:{
        if(serialConfig.manager.isConnected)
            serialConfig.manager.parity = serialConfig.partity
    }

    onStopBitsChanged: {
        if(serialConfig.manager.isConnected)
            serialConfig.manager.dataBits = serialConfig.dataBits
    }

    property string port: comList.port.currentText
    property SerialManager manager
    property alias comList : comList

    Label {
        id: label
        text: "Serial port Settings"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.topMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        height:44
    }
    SerialManagerDeviceList{
        id:comList
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: label.bottom
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.topMargin: 5
        height: 40
        scanPort:true


    }
    Label {
        id: label2
        text: "Baudrate"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: comList.bottom
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.topMargin: 5
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        height:40
    }
    ComboBox{
        id:baudRateList
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: label2.bottom
        anchors.topMargin: 0
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        currentIndex: 1
        model: [9600, 19200, 38400, 57600, 76800, 115200, 230400, 460800, 576000, 921600]
        height: 40
    }

    Label {
        id: label3
        height: 40
        text: "Number of data bits"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: baudRateList.bottom
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.rightMargin: 0
        anchors.topMargin: 5
        anchors.leftMargin: 0
    }

    ComboBox {
        id: dataBitsList
        height: 40
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: label3.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 0
        anchors.leftMargin: 10
        currentIndex: 3
        model: [5, 6, 7, 8]
    }

    Label {
        id: label4
        height: 40
        text: "Flow control"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: dataBitsList.bottom
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.rightMargin: 0
        anchors.topMargin: 5
        anchors.leftMargin: 0
    }

    ComboBox {
        id: flowControlList
        height: 40
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: label4.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 0
        anchors.leftMargin: 10
        currentIndex: 0
        model: ["None", "RTS/CTS", "XON/XOFF"]
    }

    Label {
        id: label5
        height: 40
        text: "Parity"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: flowControlList.bottom
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.rightMargin: 0
        anchors.topMargin: 5
        anchors.leftMargin: 0
    }

    ComboBox {
        id: parityList
        height: 40
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: label5.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 0
        anchors.leftMargin: 10
        currentIndex: 0
        model: ["None", "Even Partiy", "Odd Parity", "Space Parity", "Mark Parity"]
    }

    Label {
        id: label6
        height: 40
        text: "Stop bits"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parityList.bottom
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.rightMargin: 0
        anchors.topMargin: 5
        anchors.leftMargin: 0
    }

    ComboBox {
        id: stopBitsList
        height: 40
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: label6.bottom
        anchors.rightMargin: 10
        anchors.topMargin: 0
        anchors.leftMargin: 10
        currentIndex: 0
        model: ["1", "1,5", "2"]
    }

    Button{
        id:connectButton
        text:(!serialConfig.manager.isConnected) ? "Open" : "Close"
        anchors.top: stopBitsList.bottom
        anchors.horizontalCenterOffset: 0
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            if (!serialConfig.manager.isConnected)
            {
                serialConfig.manager.baudrate = serialConfig.baudrate
                serialConfig.manager.dataBits = serialConfig.dataBits
                serialConfig.manager.flowControl = serialConfig.flowControl
                serialConfig.manager.parity = serialConfig.parity
                serialConfig.manager.stopBits = serialConfig.stopBits
                serialConfig.manager.connectToPort(serialConfig.port)
            }
            else
            {
                serialConfig.manager.disconnectFromPort();
            }
        }
    }
}



/*##^##
Designer {
    D{i:0;formeditorZoom:1.25}
}
##^##*/
