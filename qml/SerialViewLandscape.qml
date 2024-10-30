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
        id:splitView
        anchors.fill: parent
        SerialTool.SerialManagerConfig{
            id:serialConfig
            SplitView.preferredWidth: 140
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
