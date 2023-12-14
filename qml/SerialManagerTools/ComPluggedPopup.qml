import QtQuick
import QtQuick.Controls
import "../Style/"


import QtQuick.Layouts
import SerialManager
import QtQuick.Window




Popup {
    id: popup
    modal: true
    focus: true
    property alias timer: timer
    property var comList: []

    property alias text: label.text
    function update_text()
    {
        label.text = "New device found:\n" + popup.comList.join(', ')
    }


    closePolicy: Popup.CloseOnPressOutsideParent | Popup.CloseOnPressOutside
    onOpened: {
        timer.running = true
    }
    onComListChanged: {
        console.log("update comlist ", popup.comList)

    }

    Shortcut {
        sequence: "Esc"
        onActivated: {
            console.log("Esc: cancel a few things")
            popup.close()
        }
    }
    Label{
        id: label
        anchors.fill: parent
        text: "New device found:\n" + popup.comList.join(', ')
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }

    Timer{
        id:timer
        interval: 4000
        running: false
        onTriggered: {
            console.log("clear Com List")
            comList.length = 0
            popup.close();
        }
    }
}
