import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    width: 300
    height: 480

    property int colorIndex: 0
    property var colors: ["red", "green", "blue", "yellow"]

    Rectangle{
        id: coloredRect
        color: "red"
        width: root.width/2

        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10

        anchors.horizontalCenter: parent.horizontalCenter

        MouseArea{
            id: ma
            anchors.fill: parent
            onClicked: {
                console.log("rect clicked")
                colorIndex = (colorIndex + 1) % colors.length
                coloredRect.color = colors[colorIndex]
            }
            onPressed: {
                coloredRect.color = "black"
            }
        }
    }

}
