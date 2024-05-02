import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore


ApplicationWindow {
    id: root
    property alias sessionRB: sessionRB
    ColumnLayout{
        id: column
        anchors.fill: parent
        height: Screen.pixelDensity * 10
        Label{
            text: "Working on it, wait for the next update"
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true

        }
        RowLayout{
            id: row
            Layout.fillWidth: true
            RadioButton{
                id: sessionRB
                text: "Join session information"
                checked: true
            }
        }
    }
    Settings {
        property alias sessionInfoState: sessionRB.checked
    }

}
