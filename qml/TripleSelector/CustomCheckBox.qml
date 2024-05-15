import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Item {
    id: root

    property alias text: text.text
    property alias checked: checker.checked
    signal released()

    RowLayout{
        id: row
        anchors.fill: parent
        spacing: 5
        Checker{
            id: checker
            width: parent.height - 5
            height: parent.height - 5
            anchors.verticalCenter: parent.verticalCenter
            Layout.preferredWidth: parent.height - 5
            onReleased: {
                root.released()
            }
        }
        Text {
            id: text
            text: "Hello"
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
            Layout.fillWidth: true
        }
     }

}
