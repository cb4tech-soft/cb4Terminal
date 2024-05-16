import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: selector
    property var checkBoxNameModel: ["ASCII", "Hex", "Mixte"]
    clip: true

    property int checkedIndex: 0
    onCheckedIndexChanged: {
        if (checkedIndex == 0) {
            checkBoxs[0].checked = true
            checkBoxs[1].checked = false
            checkBoxs[2].checked = false
        }
        else if (checkedIndex == 1) {
            checkBoxs[0].checked = false
            checkBoxs[1].checked = true
            checkBoxs[2].checked = false
        }
        else if (checkedIndex == 2) {
            checkBoxs[0].checked = false
            checkBoxs[1].checked = false
            checkBoxs[2].checked = true
        }
    }

    property var checkBoxs: [cb1, cb2, cb3]
    Component.onCompleted: {
        implicitWidth = Math.max(cb1.implicitWidth, cb2.implicitWidth, cb3.implicitWidth)
    }

//    implicitWidth: Math.max(cb3.implicitWidth, cb2.implicitWidth, cb1.implicitWidth)
    ColumnLayout {
        anchors.fill: parent
        spacing: 1
        CustomCheckBox{
            id: cb1
            Layout.fillWidth: true
            text: checkBoxNameModel[0]
            Layout.fillHeight: true
            checked: checkedIndex === 0
            onReleased: {
                if (!checked) {
                    checkedIndex = 0
                }
                else {
                    checkedIndex = 0
                }
            }
            onImplicitWidthChanged: {
                selector.implicitWidth = Math.max(cb1.implicitWidth, cb2.implicitWidth, cb3.implicitWidth)
            }


//            palette: SystemPalette
        }

        CustomCheckBox {
            id: cb2
            text: checkBoxNameModel[1]
            Layout.fillWidth: true
            Layout.fillHeight: true
            checked: checkedIndex === 1
            onReleased: {
                if (!checked) {
                    checkedIndex = 1
                }
                else {
                    checkedIndex = 0
                }
            }
            onImplicitWidthChanged: {
                selector.implicitWidth = Math.max(cb1.implicitWidth, cb2.implicitWidth, cb3.implicitWidth)
            }

        }
        CustomCheckBox {
            id: cb3
            text: checkBoxNameModel[2]
            Layout.fillWidth: true
            Layout.fillHeight: true
            checked: checkedIndex === 2
            onReleased: {
                if (!checked) {
                    checkedIndex = 2
                }
                else {
                    checkedIndex = 0
                }
            }
            onImplicitWidthChanged: {
                selector.implicitWidth = Math.max(cb1.implicitWidth, cb2.implicitWidth, cb3.implicitWidth)
            }

        }
    }
}
