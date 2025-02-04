import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

Item {
    id: control


    property var checkState: (control.checked) ? Qt.Checked : Qt.Unchecked

    property bool checked: true

    property bool down: (control.checkState === Qt.Checked)
    signal released()

    palette{
        accent: Material.accent
        base: Material.background
        light: Material.background
        text: Material.background
    }

    width: 15
    height: 15


    Rectangle{
        id: indicator
        anchors.fill: parent
        anchors.leftMargin: 1
        anchors.topMargin: 1
        anchors.rightMargin: 1
        anchors.bottomMargin: 1

        border.color: !control.enabled ? control.Material.hintTextColor
            : checkState !== Qt.Unchecked ? control.Material.accentColor : control.Material.secondaryTextColor
        border.width: checkState !== Qt.Unchecked ? width / 2 : 2

        color: control.checked ? control.palette.accent : control.palette.light
        radius: 4
        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }

        Behavior on border.width {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }

        Behavior on border.color {
            ColorAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }
    }

    // TODO: This needs to be transparent
    Image {
        id: checkImage
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 14
        height: 14
        source: "qrc:/qt-project.org/imports/QtQuick/Controls/Material/images/check.png"
        fillMode: Image.PreserveAspectFit

        scale: control.checkState === Qt.Checked ? 1 : 0
        Behavior on scale { NumberAnimation { duration: 100 } }
    }

    Rectangle {
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 12
        height: 3

        scale: control.checkState === Qt.PartiallyChecked ? 1 : 0
        Behavior on scale { NumberAnimation { duration: 100 } }
    }



    states: [
        State {
            name: "checked"
            when: control.checkState === Qt.Checked
        },
        State {
            name: "partiallychecked"
            when: control.checkState === Qt.PartiallyChecked
        }
    ]


    transitions: Transition {
        SequentialAnimation {
            NumberAnimation {
                target: control
                property: "scale"
                // Go down 2 pixels in size.
                to: 1 - 2 / control.width
                duration: 120
            }
            NumberAnimation {
                target: control
                property: "scale"
                to: 1
                duration: 120
            }
        }
    }
}
