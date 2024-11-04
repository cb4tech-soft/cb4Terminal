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

SplitView{
        id: root
        anchors.fill: parent

        property SerialManager manager
        property SerialTool.ComPluggedPopup popup

        property alias serialManagerLineSender: serialManagerLineSender
        property alias dataViewer: dataViewer

        SerialTool.SerialManagerConfig{
            id:serialConfig
            SplitView.preferredWidth: 140
            manager: root.manager
            comList.onNewComPort: function (portname){
                var i = 0
                while (i < portname.length)
                {
                    root.popup.comList.push(portname[i])
                    i++;
                }
                root.popup.update_text()
                if (sysTrayPopupEnable)
                    sysTray.showMessage("New device found",  root.popup.comList.join(', '))
                if (comPopupEnable)
                    root.popup.open()
                root.popup.timer.interval = 4000;
                root.popup.timer.running = true;

            }
            comList.scanPort: (root.scanPortEnable)? !root.manager.isConnected : false
        }
        SplitView{
            id:splitViewSerial
            orientation: Qt.Vertical
            SerialTool.SerialManagerDataViewer{
                id:dataViewer
                SplitView.fillHeight: true
                manager : root.manager
            }

            SerialTool.SerialManagerLineSender {
                id: serialManagerLineSender
                y: 0

                SplitView.preferredHeight: 80
                manager : root.manager
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
