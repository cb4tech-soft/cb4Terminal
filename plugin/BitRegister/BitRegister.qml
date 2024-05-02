import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    width: 1300
    height: 150

    property int registerValue: 42

    GridLayout {
        id: grid
        anchors.left: parent.left
        anchors.leftMargin: 1
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.top: parent.top
        columns: 32
        rows: 2
        columnSpacing: 0
        rowSpacing: 0

        Repeater {
            model: 32
            // Label for bit number
            RowLayout {
                spacing: 0
                Layout.minimumWidth: 30
                Layout.fillWidth: true
                Label {
                    text: (31 - index).toString()
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                }

                ToolSeparator {
                    width: 1
                    visible: index !== 31  // hide the last separator
                    Layout.fillHeight: true

                }
            }

        }
        Repeater {
            model: 32

            RowLayout {
                spacing: 0
                Layout.fillWidth: true
                Layout.minimumWidth: 30
                CheckBox {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    checked: (registerValue & (1 << (31 - index))) !== 0
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    z:2
                    onCheckedChanged: {
                        if (checked) {
                            registerValue |= (1 << (31 - index))
                        } else {
                            registerValue &= ~(1 << (31 - index))
                        }
                    }

                }
                ToolSeparator {
                    width: 1
                    visible: index !== 31  // hide the last separator
                    z:0
                    Layout.fillHeight: true
                }
            }
        }
    }

    Label {
        anchors.top: grid.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        //        text: "Hex: " + decimalToHexString(registerValue) + " | Dec: " + registerValue
        text: "Hex: 0x" + (registerValue>>>0).toString(16).toUpperCase() + "Dec: " + (registerValue>>>0) + "<br/>ASCII: " + String.fromCharCode(registerValue>>>0)
        Keys.onPressed: (event)=> {
                            console.log("keyUpdate", event.key, event.modifiers)
                            if (event.key < 32 || event.key > 126)
                                return
                            if (event.key  && (event.modifiers == Qt.NoModifier))
                            {
                                console.log("update registerValue")
                                registerValue = (event.key + 0x20)
                            }
                            else if (event.key  && (event.modifiers == Qt.ShiftModifier))
                            {
                                console.log("update registerValue")
                                registerValue = event.key
                            }
                        }
    }


}
