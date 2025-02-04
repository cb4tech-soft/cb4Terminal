import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

import QtQuick.Templates as T
import SerialInfo
import SerialManager

ComboBox{
    id: control
    model: internal.portList

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

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.delegateModel
            currentIndex: control.highlightedIndex
            highlightMoveDuration: 0

            T.ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            radius: 4
            color: parent.Material.dialogColor

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
