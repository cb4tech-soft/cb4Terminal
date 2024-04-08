import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    width: 300
    height: 300

    signal sendString(serialString: string)
    property bool receiveLineFeatureEnable: true
    property int seqSend: 0
    property string baseString: "00000000000000"

    function receiveString(serialString: string) {
        console.log("receiveString: " + serialString)
    }

    Button{
        id: sendButton
        text: checked ? "Stop" : "Start"
        checkable: true
        onCheckedChanged: {
            seqSend = 0
        }
    }

    SpinBox{
        id: seqNbDigit
        anchors.left: sendButton.right
        from: 1
        to: 200
        value: 9
        onValueChanged: {
            var i = 0;
            while (i < value) {
                root.baseString += "0"
                i++
            }
        }
    }

    Timer{
        running: sendButton.checked
        interval: 100
        repeat: true
        onTriggered: {
            seqSend++
            var strToSend = (baseString + seqSend.toString()).slice(-(seqNbDigit.value - 1)) + "\n"
            sendString(strToSend)
        }
    }
}
