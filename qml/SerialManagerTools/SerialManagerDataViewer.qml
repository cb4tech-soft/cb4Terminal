import QtQuick
import QtQuick.Controls.Material
import Qt.labs.platform
import  "../Style"
import SerialManager
import ComponentCacheManager
import "../TripleSelector"

import QtCore
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: appRectangle
    width: 400
    height: 300
    property alias dataView: dataView
    property alias serialData: serialData
    property alias switchRow: switchRow

    property SerialManager manager
    signal lineDataAppend(string lineData);
    signal dataAppend(string lineData);

    function logToText() {
        var chaine = []
        console.log("logToText - ")
        for(let i = 0; i < serialData.count; i++) {
            if(ctrlTime.checked) {
                //This needs to be improved...
                var timehtml = serialData.get(i).timestamp
                var timestamp = timehtml.replace("<font color=\"grey\">", "");
                timestamp = timestamp.replace("</font>", "");
                timestamp+= " : "
                chaine.push(timestamp)
            }
            chaine.push(serialData.get(i).serData)
        }
        return chaine;
    }

    function lineUpdate()
    {
        while (manager.isLineAvailable())
        {
            var dataLine = manager.readLine()
            lineDataAppend(dataLine);
            if (dataLine[dataLine.length-1] == '\n')
            {
                dataLine =  dataLine.slice(0, dataLine.length-1)
            }
            append(dataLine);
        }
    }

    function dataUpdate() {
        var dataLine = manager.readAll()
        append(dataLine)

    }

    Connections {
        target: manager
        function onLineAvailable(){ lineUpdate() }
        function onDataAvailable(){ dataUpdate() }
    }


    clip: true


    ListModel {
        id: serialData
    }

    function appendOut(outData)
    {
        //console.log("appendOut - ", outData)

        var r=""
        var i = 0;
        while (i < outData.length)
        {
            r+=String.fromCharCode(outData[i]);
            i++;
        }
        var currentDate = new Date
        var dateString = "<font color=\"grey\">" + currentDate.toLocaleTimeString(Qt.locale("fr_FR"),"h:mm:ss") + "</font>";

        serialData.append({"timestamp": dateString ,"serData": r, "isSend": true})
        //console.log(r)
    }

    function send(outData)
    {
        serManager.sendData(outData)
        if (ctrlEcho.checked)
            appendOut(outData)
    }


    function sendString(outData)
    {
        serManager.sendString(outData)
        if (ctrlEcho.checked)
            apprendOutString(outData)
    }

    function apprendOutString(outData)
    {
        //console.log("appendOutString - ", outData)

        var currentDate = new Date
        var dateString = "<font color=\"grey\">" + currentDate.toLocaleTimeString(Qt.locale("fr_FR"),"h:mm:ss") + "</font>";

        serialData.append({"timestamp": dateString ,"serData": outData, "isSend": true})
    }

    function append(outData)
    {
        //console.log("append - outData - ", outData)
        var currentDate = new Date
        var dateString = "<font color=\"grey\">" + currentDate.toLocaleTimeString(Qt.locale("fr_FR"),"h:mm:ss") + "</font>";

        //console.log("append - dateString -", dateString)
        serialData.append({"timestamp": dateString ,"serData": outData, "isSend": false})
        dataAppend(outData);
    }

    FolderDialog{
        id: saveDialog
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        title: "Select save destination :"
        onAccepted: {
            var log = logToText()
            console.log(this.currentFolder)
            ComponentCacheManager.copyToClipboard(log)
//                        manager.saveToFile(log, this.currentFolder, ctrlTime.checked)
            }
    }

    Item {
        id: dataViewController
        height: 70

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.rightMargin: 0

        Settings {
            property alias ctrlTime_state: ctrlTime.checked
            property alias ctrlScroll_state: ctrlScroll.checked
            property alias ctrlEcho_state: ctrlEcho.checked
//            property alias ctrlHex_state: ctrlHex.checked
        }
        RowLayout{
            id: switchRow
            property alias ctrlClear: ctrlClear
            property alias ctrlSave: ctrlSave
            property alias ctrlTime: ctrlTime
            property alias ctrlScroll: ctrlScroll
            property alias ctrlEcho: ctrlEcho
//            property alias ctrlHex: ctrlHex
            anchors.fill: parent
            z: 1
            anchors.topMargin: 1
            anchors.bottomMargin: 1
            layoutDirection: Qt.RightToLeft
            Rectangle{
                id:ctrlClearRect
                height: parent.height
                Button{
                    id:ctrlClear
                    text: "clear"
                    onClicked: serialData.clear()
                    height: parent.height
                }
                Button{
                    id:ctrlSave
                    text: "Save Log"
                    onClicked: {
                        var log = logToText()
    //                    console.log()
                        ComponentCacheManager.copyToClipboard(log);
    //                    saveDialog.open()
                    }
                    height: parent.height
                }
            }
            CheckBox{
                id: ctrlTime
                text: "Show Time"
                checkable: true
                checked: true
                height: parent.height
            }
            CheckBox{
                id: ctrlScroll
                text: "Auto Scroll"
                checkable: true
                checked: true
                height: parent.height
            }
            CheckBox{
                id: ctrlEcho
                text: "Echo Mode"
                checkable: true
                checked: true
                height: parent.height
            }
            CustomTripleSelector{
                id: tripleSelector
                visible: true
                height: parent.height
            }
        }

    }

    ListView {
        id: dataView
        clip: true
        height: parent.height - dataViewController.height
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        model:serialData


        ScrollBar.vertical: ScrollBar {
            id:scrollbar
            policy: ScrollBar.AlwaysOn
            active: ScrollBar.AlwaysOn

        }
        delegate: DataLine{
            id:contentLine
            showTime: ctrlTime.checked
            strData: serData
            isSendedData: isSend
            hexEnable: ctrlHex.checked
            dateString: timestamp
            width:(parent)? parent.width - scrollbar.width: 0

        }
        onCountChanged: {
            if (ctrlScroll.checked)
                scrollbar.position = 1
//                dataView.positionViewAtEnd()
        }

    }


}
