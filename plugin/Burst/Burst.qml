import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    width: 300
    height: 480

    signal sendString(serialString: string)
    property bool receiveLineFeatureEnable: false
    property bool burstEnable: false
    property int burstValue : 0
    Timer{
        id: burstTimer
        interval: 1
        running: burstEnable
        repeat: true
        onTriggered: {
            if(burstEnable){
                burstValue++
                if (burstValue < 10)
                    sendString('0' + burstValue + '\n')
                else
                    sendString(burstValue + '\n')

                if (burstValue == 99){
                    burstEnable = false
                    burstValue = 0
                }
            }
        }
    }

    Button {
        id: label
        text: qsTr("Burst Mode : ") + burstEnable
        anchors.centerIn: parent
        onClicked: {
            burstEnable = !burstEnable
        }

    }

}
