import QtQuick
import QtQuick.Controls
import "./Style"

import ComponentCacheManager

ApplicationWindow {
    id:root

    property string log

    width: 1024
    height: 768
    objectName: "logCopyView"
    visible:true

    Connections {
        target: ComponentCacheManager

        function onLogCopyText(text) {
            root.log = text
        }
    }

    AppLabel {
        id: titleLabel

        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter

        font.pointSize: 18

        text: "Log dump :"
    }

    ScrollView {
        id: scrollview

        anchors.top: titleLabel.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        TextArea {
            width: root.width
            height: contentHeight
            wrapMode: "WordWrap"
            readOnly: true
            text: root.log
        }
    }
}
