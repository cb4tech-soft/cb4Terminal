import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


import SoftwareLauncher

ApplicationWindow {
    width: 300
    height: 480

    property var argumentList : {"demoFile.txt"}

    signal sendString(serialString: string)
    property bool receiveLineFeatureEnable: true

    function startProgram(softwarePath: string){
        SoftwareLauncher.launchSoftware(softwarePath, argumentList)
    }

    function receiveString(serialString: string) {
        console.log("receiveString: " + serialString)
        label.text = serialString
    }
    Rectangle{
        color: "red"
        width: 100
        height: 100
        MouseArea{
            anchors.fill: parent
            onClicked: {
                sendString("Hello RED")
            }
        }
    }


    Label {
        id: label
        text: qsTr("Hello World")
        anchors.centerIn: parent
        height: 50
    }
    RowLayout{
        anchors.top: label.bottom
        anchors.topMargin: 50
        anchors.verticalCenter: parent
        height: 40
        width: parent.width * 0.8
        TextField{
            id: input
            text: "notepad.exe"
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Button{
            text: "lauch"
            onClicked: startProgram(input.text)
            Layout.fillHeight: true
        }
    }

}
