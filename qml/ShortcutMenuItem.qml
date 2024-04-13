import QtQuick
import QtQuick.Controls
import QtQuick.Layouts 1.12


MenuItem {
    id: root

    property alias sequence: _shortcut.sequence

    Shortcut {
        id: _shortcut
        enabled: root.enabled
        onActivated: root.triggered()
        autoRepeat: false
    }

    contentItem: RowLayout {
        spacing: 0
        width: root.width
        opacity: root.enabled ? 1 : 0.5

        Label {
            id: mainLabel
            text: root.text
            Layout.fillWidth: true
            elide: Label.ElideRight
            verticalAlignment: Qt.AlignVCenter
        }
        Label {
            text: _shortcut.nativeText
            verticalAlignment: Qt.AlignVCenter
            Layout.preferredWidth: root.width / 4
            fontSizeMode: Text.Fit
            Layout.rightMargin: 4
        }
    }
}
