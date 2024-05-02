import QtQuick 2.0
import SerialManager 1.0
import QtQuick.Controls 2.12
import SerialInfo 1.0

ComboBox{
    id: port
    model: internal.portList
    QtObject{
        id:internal
        property var portList: []
    }
    property alias port: port
    property bool scanPort: false

    signal newComPort(var portName)
    function compareArrays(arr1, arr2) {
        return arr2.filter(item => !arr1.includes(item));
    }
    function updateList()
    {
        internal.portList = SerialInfo.getPortList()
    }
    Timer{
        id: timer
        repeat: true
        running: scanPort
        interval: 1000
        onTriggered: {
            var oldPortList = internal.portList
            updateList()
            var newList = compareArrays(oldPortList, internal.portList)
            if (newList.length)
            {
                console.log(newList)
                newComPort(newList)
            }
        }
    }

    Component.onCompleted: {
        updateList();
        console.log(internal.portList)
        port.currentIndex = port.count-1
    }

        onDownChanged: {
            if (down)
                updateList()
        }


}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
