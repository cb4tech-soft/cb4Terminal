import QtQuick
import QtQuick.Controls
import  "../Style"
import SerialManager
import QtQuick.Layouts

import QtCore


Item {
    id:root
    property SerialManager manager
    width: 600
    height: 80
    property var hexSeparator: [',', ' ', '-', ';', ':', '\n']
    signal sendStringData(var stringData);
    signal sendHexaData(var hexaData);
    property alias textInput: textLine.text
    function hexToBytes(hexStr) {
        let separator = null;
        for (let i = 0; i < hexStr.length; i++) {
            if (root.hexSeparator.includes(hexStr[i])) {
                separator = hexStr[i];
                break;
            }
        }
        // Split the string by the found separator
        const parts = hexStr.split(separator);

        // Filter out empty strings and convert to byte array
        const bytes = parts
                .filter(part => part.trim() !== '')
                .map(part => {
                    // Remove remaining separators from part
                    for (let sep of root.hexSeparator) {
                        part = part.replace(new RegExp(sep, 'g'), '');
                    } // Check if part is a valid hexadecimal string
                    if (/^[0-9A-Fa-f]+$/.test(part)) {
                    return parseInt(part, 16);
                    } else {
                    return NaN;
                    }
                });
        const filteredArray = bytes.filter((value) => !isNaN(value));

        return filteredArray;
    }

    function triggerSend() {
        if (!textLine.text.length)
            return
        var stringToSend = textLine.text

        if(switchHex.checked) {
            var error = false
            var bytes = hexToBytes(stringToSend)
            //console.log(bytes)
            if(!error) {
                //textLine.backgroundColor = AppStyle.backgroundLight
                stringToSend = bytes
                switch(comboCRLF.currentIndex) {
                    case 0:
                        break
                    case 1:
                        stringToSend.push(10)
                        break
                    case 2:
                        stringToSend.push(13)
                        break
                    case 3:
                        stringToSend.push(13)
                        stringToSend.push(10)
                        break
                    case 4:
                        stringToSend.push(0)
                    break
                }
                sendHexaData(stringToSend)
            }
       } else {
            //textLine.backgroundColor = AppStyle.backgroundLight
            switch(comboCRLF.currentIndex) {
                case 0:
                    break
                case 1:
                    stringToSend+= "\n"
                    break
                case 2:
                    stringToSend+= "\r"
                    break
                case 3:
                    stringToSend+= "\r\n"
                    break
                case 4:
                    stringToSend+= "\0"
                    break
            }
            sendStringData(stringToSend)
        }
    }

    focus: true


    ColumnLayout{
        id:sendLayout
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        spacing: 1
        anchors.bottomMargin: 4
        anchors.rightMargin: 8
        anchors.right: parent.right

        width: (advancedMode)?(repeatTime.implicitWidth): Screen.pixelDensity*25
        property bool advancedMode: false

        SpinBox{
            id:repeatTime
            Layout.fillWidth: true
            Layout.preferredHeight: sendButton.height - 4
            visible: sendLayout.advancedMode
            stepSize: 100
            to: 10000
            from: 1
            value: 500
            editable: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

            TextMetrics{
                id:     t_metrics
                font:   repeatTime.font
                text:   repeatTime.displayText
            }
        }

        Button{
            id: sendButton
            text: (sendLayout.advancedMode) ?
                     (!timerRepeat.running) ? "Send " + repeatTime.value + " ms" : "stop"
                                            : "Send"
            Layout.bottomMargin: 3
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.preferredHeight: (root.height > 60) ? 40 : root.height - 20
            onClicked: {
                if (sendLayout.advancedMode) {
                    if (timerRepeat.running) {
                        timerRepeat.stop()
                    }
                    else {
                        timerRepeat.start()
                    }
                }
                else {
                    triggerSend()
                }
            }
            onPressAndHold: {
                sendLayout.advancedMode = !sendLayout.advancedMode
            }
            Timer{
                id:timerRepeat
                repeat: true
                interval: repeatTime.value
                running: false
                onTriggered: {
                    triggerSend()
                }
            }

        }
    }
    ScrollView{
        id: textLineView
        anchors.left: parent.left
        anchors.right: columnOption.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.topMargin: 10
        anchors.bottomMargin: 5
        TextArea{
            id: textLine
            horizontalAlignment: Text.AlignLeft
            enabled: serialConfig.manager.isConnected
            placeholderText: (switchHex.checked) ? "4A,01,CB,47" : "Hello World!"
            anchors.top: parent.top
            anchors.topMargin: 4

            Keys.onReleased: (event) => {
                if ((event.key == Qt.Key_Return || event.key == Qt.Key_Enter) && !(event.modifiers & Qt.ShiftModifier)) {
                    var pos = cursorPosition
                    text = text.substring(0, pos - 1) + text.substring(pos, text.length)
                    cursorPosition = text.length
                    triggerSend()
                }
            }

        }
    }

    Settings {
        property alias comboCRLF_index: comboCRLF.currentIndex
        property alias switchHex_state: switchHex.checked
    }
    ColumnLayout{
        id: columnOption
        anchors.right: sendLayout.left
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.bottom: parent.bottom
        anchors.rightMargin: 5
        spacing: 1
        Switch {
            id: switchHex
            text: "Hex  "
            Layout.fillHeight: true
        }

        ComboBox {
            id: comboCRLF
            model: ["No CRLF", "\\n", "\\r", "\\r\\n", "\\0"]
            height: 37
            Layout.fillHeight: true
            anchors.rightMargin: 5
        }
    }
}
