import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Item {
    id: root
    implicitWidth: checker.width + text.contentWidth + row.spacing
    property alias text: text.text
    property alias checked: checker.checked
    signal released()

    RowLayout{
        id: row
        anchors.fill: parent
        spacing: 5
        Checker{
            id: checker
            Layout.preferredWidth: parent.height - 5
            Layout.preferredHeight: parent.height - 5
        }
        Text {
            id: text
            text: "Hello"
            font.pixelSize: 14
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
     }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
//            checker.checked = !checker.checked
            root.released()
        }
        z:2
    }

}
