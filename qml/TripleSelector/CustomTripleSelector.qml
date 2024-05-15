import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    property var checkBoxNameModel: ["ASCII", "Hex", "Mixte"]

    property int checkedIndex: 0
    onCheckedIndexChanged: {
        if (checkedIndex == 0) {
            console.log(checkBoxNameModel[0] + " checked")
            checkBoxs[0].checked = true
            checkBoxs[1].checked = false
            checkBoxs[2].checked = false
        }
        else if (checkedIndex == 1) {
            console.log(checkBoxNameModel[1] + " checked")
            checkBoxs[0].checked = false
            checkBoxs[1].checked = true
            checkBoxs[2].checked = false
        }
        else if (checkedIndex == 2) {
            console.log(checkBoxNameModel[2] + " checked")
            checkBoxs[0].checked = false
            checkBoxs[1].checked = false
            checkBoxs[2].checked = true
        }
    }

    property var checkBoxs: [cb1, cb2, cb3]

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
                console.log("released HighLevel, checked: " + checked)
                if (!checked) {
                    checkedIndex = 0
                }
                else {
                    checkedIndex = 0
                }
            }
            Rectangle{
                color: "transparent"
                border.color: "black"
                border.width: 1
                anchors.fill: parent
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
                console.log("released HighLevel, checked: " + checked)

                if (!checked) {
                    checkedIndex = 1
                }
                else {
                    checkedIndex = 0
                }
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
        }
    }
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: "black"
    }
}
