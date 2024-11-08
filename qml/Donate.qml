import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Rectangle {
    id:root
    property int catIndex: Math.ceil(Math.random() * 19)

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

    ColumnLayout{
        anchors.fill: parent
        Label{
            text: "If you like this term and you want to support me\n"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.pointSize: 13
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

        }

        Image {
            id: image
            x: 270
            y: 190
            width: 100
            height: 100
            source: "qrc:/qml/image/resized/" + catIndex + ".jpg"
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            fillMode: Image.PreserveAspectFit
        }
        TextArea{
            id:textArea
            text: "Send me a tips on <a href = \"https://www.paypal.com/donate/?hosted_button_id=8AV4Q64GQJ8CC\">paypal</a>"
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            font.pointSize: 13
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            selectByMouse: true
            selectByKeyboard: true
            readOnly: true
            onLinkActivated: {
                console.log(link)
                Qt.openUrlExternally(link)
            }

        }

        Button{
            id: closeButton
            onClicked: root.visible = false
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            text: "close"
        }
    }
}
