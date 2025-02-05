import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl


import QtQuick.Templates as T

import SerialInfo
import SerialManager

import "../generic/material"

ComboBox{
    id: control
    model: internal.portList
    property SerialManager manager


    QtObject{
        id:internal
        property var portList: []
    }
    property alias port: control
    property bool scanPort: false

    signal newComPort(var portName)

    function compareArrays(arr1, arr2) {
        return arr2.filter(item => !arr1.includes(item));
    }

    function updateList()
    {
        internal.portList = SerialInfo.getPortList()
    }

    Timer{
        id: timer
        repeat: true
        running: control.scanPort
        interval: 1000
        onTriggered: {
            var oldPortList = internal.portList
            control.updateList()
            var newList = control.compareArrays(oldPortList, internal.portList)
            if (newList.length)
            {
                console.log(newList)
                control.newComPort(newList)
            }
        }
    }

    delegate: MenuItem {
        required property var model
        required property int index

        width: ListView.view.width
        text: model[control.textRole]
        Material.foreground: control.currentIndex === index ? ListView.view.contentItem.Material.accent : ListView.view.contentItem.Material.foreground
        highlighted: control.highlightedIndex === index
        hoverEnabled: control.hoverEnabled

        // onClicked: {
        //     ToolTip.show(manager.getComInfo(model[control.textRole]), 5000)
        // }


        MaterialDesignIcon {
            id: infoButton
            name: "information"
            color: (ma.containsMouse) ? Qt.darker("dodgerblue", 1.15) :  "dodgerblue"
            scale: (ma.containsMouse) ? 0.75 : 0.7
            width: parent.height
            height: parent.height
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            visible: control.highlightedIndex === index
            MouseArea {
                id: ma
                anchors.fill: parent
                hoverEnabled: true
                ToolTip.delay: 250
                ToolTip.timeout: 5000
                ToolTip.visible: ma.containsMouse
                ToolTip.text: control.manager.getComInfo(model[control.textRole])
            }
            Behavior on scale { NumberAnimation { duration: 200 ; easing.type: Easing.InOutQuart; } }
        }
    }

    popup: T.Popup {
        y: control.editable ? control.height - 5 : 0
        width: control.width
        height: Math.min(contentItem.implicitHeight + verticalPadding * 2, control.Window.height - topMargin - bottomMargin)
        transformOrigin: Item.Top
        topMargin: 12
        bottomMargin: 12
        verticalPadding: 8

        Material.theme: control.Material.theme
        Material.accent: control.Material.accent
        Material.primary: control.Material.primary

        enter: Transition {
            // grow_fade_in
            NumberAnimation { property: "scale"; from: 0.9; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; from: 0.0; easing.type: Easing.OutCubic; duration: 150 }
        }

        exit: Transition {
            // shrink_fade_out
            NumberAnimation { property: "scale"; to: 0.9; easing.type: Easing.OutQuint; duration: 220 }
            NumberAnimation { property: "opacity"; to: 0.0; easing.type: Easing.OutCubic; duration: 150 }
        }

        contentItem: ListView{
            leftMargin: 5
            implicitHeight: contentHeight
            keyNavigationEnabled: true
            model:control.popup.visible ? control.delegateModel : null
            clip: true
            focus: true
            currentIndex: control.highlightedIndex
        }
        background: Rectangle {
            radius: 4
            color: parent.Material.dialogColor
            //            color: "blue"

            layer.enabled: control.enabled
            layer.effect: RoundedElevationEffect {
                elevation: 4
                roundedScale: Material.ExtraSmallScale
            }
        }
    }

    Component.onCompleted: {
        updateList();
        console.log(internal.portList)
        control.currentIndex = control.count-1
    }

    onDownChanged: {
        if (down)
            updateList()
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
