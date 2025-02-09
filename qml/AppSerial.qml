import QtQuick
import QtQuick.Controls


import QtQuick.Layouts
import SerialManager
import QtQuick.Window
import Qt.labs.platform as Platform


import "SerialManagerTools" as SerialTool
import MyScreenInfo

import PluginInfo

import QtCore
import 'qrc:/js/fileStringTools.js' as FileStringTools

import ComponentCacheManager
import AppInfo

ApplicationWindow {
    id:root
    property bool scanPortEnable : true
    property bool clearOnSend : false
    property bool sysTrayPopupEnable: true
    property bool comPopupEnable : true
    property alias serManager: serManager
    property alias dataViewer: dataViewer
    property alias exportView: exportView
    property alias serialManagerLineSender: serialManagerLineSender

    visible: true
    width:850
    title: "CB4Terminal :" + AppInfo.getVersionName()

    Component.onCompleted: {
        root.height = Math.min(MyScreenInfo.getScreenInfo(x,  y).height - 100, 850)
        root.y = MyScreenInfo.getScreenInfo(x,  y).height - root.height - 100
        if (root.y < 25) root.y = 25
    }

    Settings {
        property alias scanPortEnable: root.scanPortEnable
        property alias clearOnSend: root.clearOnSend
        property alias sysTrayPopupEnable: root.sysTrayPopupEnable
        property alias comPopupEnable: root.comPopupEnable
    }
    Connections {
        target: PluginInfo
        function onPluginFilesChanged() {
            console.log(PluginInfo.pluginFiles)
        }
    }

    menuBar: AppSerialMenu{}

    Repeater{
        id: pluginLoader
        model: PluginInfo.pluginFiles
        Loader{
            id: pluginLoaderItem
            active: false
            function deactivate(){
                pluginLoaderItem.active = false
                console.log("deactivate")

                ComponentCacheManager.trim()
                pluginLoaderItem.source = ""
            }
            Connections {
                target: pluginLoaderItem.item
                function onClosing() {
                    pluginLoaderItem.deactivate()
                    pluginLoaderItem.source = ""
                }
                function onSendString(serialString) {
                   // console.log(serialString)
                    serialManagerLineSender.sendStringData(serialString)
                }
            }
            Connections {
                target: dataViewer
                function onLineDataAppend(lineData) {
                    if (pluginLoaderItem.active && pluginLoaderItem.item && pluginLoaderItem.item.receiveLineFeatureEnable)
                    {
                        pluginLoaderItem.item.receiveString(lineData);
                    }
                }
                function onDataAppend(data) {
                    if (pluginLoaderItem.active && pluginLoaderItem.item && pluginLoaderItem.item.receiveDataFeatureEnable)
                    {
                        pluginLoaderItem.item.receiveData(data);
                    }
                }
            }

            Component.onCompleted: {
                console.log(index, "complete loader")
            }
        }
    }


    Donate{
        id:donation
        anchors.fill:parent
        z:10
        visible: false
    }

    ShortcutHelp{
        id:shortcutHelp
        anchors.fill:parent
        z:10
        visible: false
    }

    ExportView{
        id: exportView
        width : ScreenInfo.width * 0.8
        height :ScreenInfo.height * 0.8
    }

    SerialTool.ComPluggedPopup {
        id: popup
        anchors.centerIn: Overlay.overlay
        height: 300
        width: 200
    }

    SerialManager{
        id: serManager
        baudrate: SerialManager.Baud19200
    }
    SplitView{
        id:splitView
        anchors.fill: parent
        SerialTool.SerialManagerConfig{
            id:serialConfig
            SplitView.preferredWidth: 140
            SplitView.maximumWidth: root.width/2
            manager: serManager
            comList.onNewComPort: function (portname){
                var i = 0
                while (i < portname.length)
                {
                    popup.comList.push(portname[i])
                    i++;
                }
                popup.update_text()
                if (sysTrayPopupEnable)
                    sysTray.showMessage("New device found",  popup.comList.join(', '))
                if (comPopupEnable)
                    popup.open()
                popup.timer.interval = 4000;
                popup.timer.running = true;

            }
            comList.scanPort: (root.scanPortEnable)? !serManager.isConnected : false
        }
        SplitView{
            id:splitViewSerial
            orientation: Qt.Vertical
            SerialTool.SerialManagerDataViewer{
                id:dataViewer
                SplitView.fillHeight: true
                manager : serManager
            }

            SerialTool.SerialManagerLineSender {
                id: serialManagerLineSender
                y: 0

                SplitView.preferredHeight: 80
                manager : serManager
                onSendStringData: function(stringData){
                    dataViewer.sendString(stringData);
                    if (root.clearOnSend)
                        serialManagerLineSender.textInput = ""
                }
                onSendHexaData: function(hexaData){
                    dataViewer.send(hexaData)
                    if (root.clearOnSend)
                        serialManagerLineSender.textInput = "" }
            }
        }
    }


    Platform.SystemTrayIcon {
        id:sysTray
        visible: root.sysTrayPopupEnable
        icon.source: "qrc:/qml/icon/logo1.ico"
        menu: Platform.Menu {
            Platform.MenuItem {
                text: qsTr("New instance")
                onTriggered: ComponentCacheManager.createNewInstance()
            }
            Platform.MenuItem {
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }

        }
        onMessageClicked: console.log("Message clicked")
    }
    AppShortcut{}

}


