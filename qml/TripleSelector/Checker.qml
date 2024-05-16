import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Templates as T
import QtQuick.Controls.Material

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
        border.color: "black"

        border.width: 1
        color: control.checked ? control.palette.accent : control.palette.light
        radius: 5
        Behavior on color {
            ColorAnimation {
                duration: 100
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
