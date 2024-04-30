import QtQuick

Item {

    Shortcut{
        // CTRL + L to clear the data
        sequence: "Ctrl+L";
        onActivated: dataViewer.serialData.clear()
    }

    Shortcut{
        // CTRL + H switch hexa mode
        sequence: "Ctrl+H";
        onActivated: dataViewer.switchRow.ctrlHex.toggle()
    }
    Shortcut{
        // CTRL + T switch Time mode
        sequence: "Ctrl+T";
        onActivated: dataViewer.switchRow.ctrlTime.toggle()
    }
    Shortcut{
        // CTRL + E switch echo mode
        sequence: "Ctrl+E";
        onActivated: dataViewer.switchRow.ctrlEcho.toggle()
    }

    Shortcut{
        // CTRL + enter to open serial port
        sequence: "Ctrl+RETURN";
        onActivated: serialConfig.connectButton.clicked();
    }
    Shortcut{
        // CTRL + UP to change COM in combobox
        sequence: "Ctrl+UP";
        onActivated: {
            var index = serialConfig.comList.currentIndex - 1
            if (index < 0)
                index = serialConfig.comList.count - 1
            serialConfig.comList.currentIndex = index
        }
    }
    Shortcut{
        // CTRL + DOWN to change COM in combobox
        sequence: "Ctrl+DOWN";
        onActivated: {
            var index = serialConfig.comList.currentIndex +1
            if (index > serialConfig.comList.count - 1)
                index = 0
            serialConfig.comList.currentIndex = index
        }
    }
    Shortcut{
        // CTRL + UP to change BAUDRATE in combobox
        sequence: "Shift+DOWN";
        onActivated: {
            var index = serialConfig.baudrateCB.currentIndex - 1
            if (index < 0)
                index = serialConfig.baudrateCB.count - 1
            serialConfig.baudrateCB.currentIndex = index
        }
    }
    Shortcut{
        // CTRL + DOWN to change BAUDRATE in combobox
        sequence: "Shift+UP";
        onActivated: {
            var index = serialConfig.baudrateCB.currentIndex +1
            if (index > serialConfig.baudrateCB.count - 1)
                index = 0
            serialConfig.baudrateCB.currentIndex = index
        }
    }
}
