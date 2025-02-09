import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Rectangle {
    id:root
    ListModel{
        id: listModel
        ListElement{
            shortcut: "Ctrl + Shift + N"
            description: "New window"
        }
        ListElement{
            shortcut: "Ctrl + Shift + L"
            description: "Log copy view"
        }
        ListElement{
            shortcut: "Ctrl + Q"
            description: "Quit"
        }
        ListElement{
            shortcut: "Ctrl + L"
            description: "Clear display"
        }
        ListElement{
            shortcut: "Ctrl + H"
            description: "Switch hexa mode"
        }
        ListElement{
            shortcut: "Ctrl + T"
            description: "Switch Time mode"
        }
        ListElement{
            shortcut: "Ctrl + E"
            description: "Switch echo mode"
        }
        ListElement{
            shortcut: "Ctrl + Enter"
            description: "Open serial port"
        }
        ListElement{
            shortcut: "Ctrl + Up"
            description: "Change COM port in combobox (UP)"
        }
        ListElement{
            shortcut: "Ctrl + Down"
            description: "Change COM port in combobox (DOWN)"
        }
        ListElement{
            shortcut: "Shift + Up"
            description: "Change BAUDRATE in combobox (UP)"
        }
        ListElement{
            shortcut: "Shift + Down"
            description: "Change BAUDRATE in combobox (DOWN)"
        }
    }

    ListView{
        model: listModel
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.topMargin: 10
        anchors.rightMargin: 10
        delegate: Item {
            width: parent.width
            height: Screen.pixelDensity * 10
            RowLayout{
                anchors.fill: parent
                Label{
                    text: model.shortcut
                    Layout.preferredWidth: Screen.pixelDensity * 50
                    fontSizeMode: Text.Fit
                }
                ToolSeparator{
                    orientation: Qt.Vertical
                    clip: true
                    Layout.maximumHeight: 25
                }
                Label{
                    Layout.fillWidth: true
                    text: model.description
                    fontSizeMode: Text.Fit
                }
            }
        }
    }
    Button{
        text: "Close"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            root.visible = false
        }
    }

    Button{
        text: "X"

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 20

        width: height

        onClicked: {
            root.visible = false
        }
    }
}
