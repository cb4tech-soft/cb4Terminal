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
    property var glyphsInfo: Object.keys(root.glyphs)
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

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 5
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 50
            color: "#ececec"

            TextField {
                id: searchBar
                anchors.fill: parent
                placeholderText: "Rechercher des icônes..."
                padding: 10

                onTextChanged: {
                    console.log("searchBar.text ", searchBar.text)
                    if (searchBar.text === "") {
                        glyphsInfo = Object.keys(root.glyphs)
                    } else {
                        glyphsInfo = Object.keys(root.glyphs).filter(function (item) {
                            return item.toLowerCase().includes(searchBar.text.toLowerCase())
                        })
                    }
                }
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            
            GridView {
                id: gridView
                model: glyphsInfo
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

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true

                        onHoveredChanged: {

                        }
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.centerIn: parent
                        clip: true

                        Text {
                            font.family: materialFont.name
                            font.pointSize: 36
                            text: root.glyphs[gridView.model[index]]
                            color: "blue"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        TextEdit {
                            text: gridView.model[index]
                            font.pointSize: 8
                            color: "black"
                            wrapMode: Text.WrapAnywhere
                            horizontalAlignment: Text.AlignHCenter
                            Layout.fillWidth: true
                            Layout.leftMargin: 1
                            Layout.rightMargin: 1
                            readOnly: true
                            selectByMouse: true

                        }
                    }
                }
            }
        }
    }
}
