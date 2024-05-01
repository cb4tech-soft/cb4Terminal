import QtQuick
import QtQuick.Controls
import "./Style/"


import QtQuick.Layouts
import SerialManager
import QtQuick.Window
import Qt.labs.platform as Platform


import "SerialManagerTools" as SerialTool

import FileUtils

AppSerial{
    id:winSerial
    objectName: "winSerial"
    visible:true

    Timer{
        interval: 1000
    }

    Component.onCompleted: {
        var diskList = FileUtils.getDiskList()
        for(var i = 0; i < diskList.length; i++){
            console.log(diskList[i])
            var diskInfo = FileUtils.getDriveInfo(diskList[i])
            console.log(diskInfo)
        }
    }
}



