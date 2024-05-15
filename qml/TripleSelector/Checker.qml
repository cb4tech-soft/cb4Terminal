import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Controls.Material

Item {
    id: control


    property var checkState: (control.checked) ? Qt.Checked : Qt.Unchecked

    property bool checked: true
    onCheckedChanged: {
        console.log("low level checked changed ", checked)
    }

    property bool down: (control.checkState === Qt.Checked)
    signal released()

    onDownChanged: {
        console.log("down changed" + control.down)
    }

    palette{
        accent: Material.accent
        base: Material.background
        light: Material.background
        text: Material.background
    }

    Component.onCompleted: {
        console.log("control completed")
        console.log("base:", palette.base)
        console.log("light:", palette.light)
        console.log("text:", palette.text)
        console.log("accent:", palette.accent)
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
        border.color: "black"

        border.width: 1
        color: control.checked ? control.palette.accent : control.palette.light
        radius: 5
        MouseArea{
            id: ma
            anchors.fill: parent
            onReleased: {
                console.log("released")
                control.released()
            }
        }
    }

    ColorImage {
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        defaultColor: "#353637"
        color: control.palette.text
        source: "qrc:/qt-project.org/imports/QtQuick/Controls/Basic/images/check.png"
        visible: control.checkState === Qt.Checked
        anchors.fill: parent

    }
}
