import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

import "qrc:/qml/generic/material"
import "qrc:/qml/generic/material/MaterialDesignIconGlyphs.js" as MaterialGlyphs

ApplicationWindow {
    width: 440
    height: 480
    property var glyphs:MaterialGlyphs.glyphs

    FontLoader {
        id: materialFont
        source: "qrc:/qml/generic/material/materialdesignicons-webfont.ttf"
    }
    ScrollView {
        anchors.fill: parent

        GridView {
            id: gridView
            anchors.fill: parent
            cellWidth: 110
            cellHeight: 110
            model: Object.keys(glyphs).length

            delegate: Rectangle {
                width: 100
                height: 100
                color: "lightgrey"
                border.color: "grey"
                radius: 10

                ColumnLayout {
                    anchors.fill: parent
                    anchors.centerIn: parent
                    clip:true

                    Text {
                        font.family: materialFont.name
                        font.pointSize: 36

                        text: glyphs[Object.keys(glyphs)[index]]
                        color: "blue"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: Object.keys(glyphs)[index]
                        font.pointSize: 8
                        color: "black"
                        wrapMode: Text.WrapAnywhere
                        fontSizeMode: Text.Fit
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                        Layout.leftMargin: 1
                        Layout.rightMargin: 1
                    }
                }
            }
        }
    }

    Component.onCompleted:{
        console.log("nbIcon " , Object.keys(MaterialGlyphs.glyphs).length)
    }
}
