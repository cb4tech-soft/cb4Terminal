import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts
import QtCore

import "qrc:/qml/generic/material"
import "qrc:/qml/generic/material/MaterialDesignIconGlyphs.js" as MaterialGlyphs

ApplicationWindow {
    id: root

    property var glyphs: MaterialGlyphs.glyphs
    /*
    Settings {
        id: settings
        property var starredModel : []
    }
*/
    width: 440
    height: 480


    FontLoader {
        id: materialFont
        source: "qrc:/qml/generic/material/materialdesignicons-webfont.ttf"
    }

    ScrollView {
        anchors.fill: parent
        GridView {

            id: gridView
            model: Object.keys(root.glyphs)
            anchors.fill: parent
            cellWidth: 110
            cellHeight: 110


            delegate: Rectangle {
                id: inner_iconDelegate
                width: 100
                height: 100
                color: "lightgrey"
                border.color: "grey"
                radius: 10
                property bool starred
                required property int index

                ColumnLayout {
                    anchors.fill: parent
                    anchors.centerIn: parent
                    clip:true

                    Text {
                        font.family: materialFont.name
                        font.pointSize: 36

                        text: root.glyphs[Object.keys(root.glyphs)[index]]
                        color: "blue"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: Object.keys(root.glyphs)[index]
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
                /*
                MaterialDesignIcon {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    size: 28
                    name: !inner_iconDelegate.starred ? "star" : "star-off"

                    color: "black"

                    MaterialDesignIcon {
                        anchors.centerIn: parent
                        size: parent.size - 4
                        name: parent.name
                        color: inner_iconDelegate.starred ? "gold" : "white"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("clicked ", index, parent.name, inner_iconDelegate.starred)
                                if (st_glyphs[index]) {
                                    st_glyphs[index] = false
                                } else {
                                    st_glyphs[index] = true
                                }
                                console.log("starred ", st_glyphs[index], inner_iconDelegate.starred)
                            }
                        }
                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                            }
                        }
                    }
                }
                */
            }
        }
    }

}
