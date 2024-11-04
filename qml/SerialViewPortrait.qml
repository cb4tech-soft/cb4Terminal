import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SerialManager
import QtQuick.Window
import Qt.labs.platform as Platform

import "SerialManagerTools/Portrait"
import MyScreenInfo

import PluginInfo

import QtCore
import 'qrc:/js/fileStringTools.js' as FileStringTools

import ComponentCacheManager
import AppInfo

Rectangle {
    id: root

    property SerialManager manager

    property alias serialManagerLineSender: testLabel
    property alias dataViewer: testLabel

    color: "lavender"

    Label {
        id: testLabel
        anchors.centerIn: parent
        text: "PHONE VIEW"
    }

    PortraitLineSender {
        id: lineSender

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        manager: root.manager
    }
}
