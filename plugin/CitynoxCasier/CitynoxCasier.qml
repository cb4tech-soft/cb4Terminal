import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


import SoftwareLauncher

ApplicationWindow {
    width: 300
    height: 480

    signal sendString(serialString: string)
    signal sendHexa(serialString: string)
    property bool receiveLineFeatureEnable: true

    property int currentTestId: 0
    property bool isTesting: false
    
    // Propriétés pour les données du mode test
    property int testNumber: 0
    property string deviceId: ""
    property string deviceType: ""
    property bool highContact1: false
    property bool highContact2: false
    property int highCurrent: 0
    property bool lowContact1: false
    property bool lowContact2: false
    property int lowCurrent: 0
    property bool testModeActive: false

    Timer {
        id: testTimer
        interval: 100 // 100ms entre chaque test
        repeat: true
        running: isTesting
        onTriggered: {
            if (currentTestId <= 254 && newIdField.text) {
                var currentIdHex = currentTestId.toString(16).padStart(2, '0')
                sendHexa(currentIdHex + " 07 " + newIdField.text + " 00")
                currentTestId++
            } else {
                isTesting = false
                currentTestId = 0
            }
        }
    }

    Timer {
        id: testModeTimer
        interval: 1000 // 1 seconde
        repeat: true
        running: testModeActive
        onTriggered: {
            if (globalIdField.text && testModeActive) {
                sendHexa(globalIdField.text + " 0d 00 50")
            }
        }
    }

    function receiveString(serialString: string) {
        console.log("receiveString: " + serialString)
        
        // Parser les trames du mode test
        if (serialString.includes("F103 id") || serialString.includes("F030 id") || serialString.includes("F403 id")) {
            // Première trame : extraction de l'ID et du type
            var idMatch = serialString.match(/id (\d+)/)
            var typeMatch = serialString.match(/(F\d+)/)
            if (idMatch) deviceId = idMatch[1]
            if (typeMatch) deviceType = typeMatch[1]
        } else if (serialString.includes(";H[") && serialString.includes("];L[")) {
            // Seconde trame : données des contacts et courant
            var parts = serialString.split(";")
            if (parts.length >= 3) {
                // Numéro de test
                testNumber = parseInt(parts[0]) || 0
                
                // Parser H[contact1|contact2|courant]
                var hMatch = parts[1].match(/H\[(\d+)\|(\d+)\|([0-9A-Fa-f]+)\]/)
                if (hMatch) {
                    highContact1 = parseInt(hMatch[1]) === 1
                    highContact2 = parseInt(hMatch[2]) === 1
                    highCurrent = parseInt(hMatch[3])
                }
                
                // Parser L[contact1|contact2|courant]
                var lMatch = parts[2].match(/L\[(\d+)\|(\d+)\|([0-9A-Fa-f]+)\]/)
                if (lMatch) {
                    lowContact1 = parseInt(lMatch[1]) === 1
                    lowContact2 = parseInt(lMatch[2]) === 1
                    lowCurrent = parseInt(lMatch[3])
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        GroupBox {
            title: "Numéro de Casier"
            Layout.fillWidth: true

            TextField {
                id: globalIdField
                anchors.fill: parent
                placeholderText: "ID du casier (ex: 80)"
                validator: RegularExpressionValidator { regularExpression: /[0-9a-fA-F]{2}/ }
            }
        }

        GroupBox {
            title: "Mode Test"
            Layout.fillWidth: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 5

                Button {
                    text: "Entrer en Mode Test"
                    Layout.fillWidth: true
                    onClicked: {
                        if (globalIdField.text) {
                            sendHexa(globalIdField.text + " 0d 00 50")
                            testModeActive = true
                        }
                    }
                }

                Button {
                    text: "Sortir du Mode Test"
                    Layout.fillWidth: true
                    enabled: testModeActive
                    onClicked: {
                        testModeActive = false
                        // Reset des valeurs
                        testNumber = 0
                        deviceId = ""
                        deviceType = ""
                        highContact1 = false
                        highContact2 = false
                        highCurrent = 0
                        lowContact1 = false
                        lowContact2 = false
                        lowCurrent = 0
                    }
                }
            }
        }

        GroupBox {
            title: "Affichage Mode Test"
            Layout.fillWidth: true
            visible: testModeActive

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                // Informations générales
                RowLayout {
                    Layout.fillWidth: true
                    Label {
                        text: "ID Casier: " + deviceId
                        font.bold: true
                    }
                    Label {
                        text: "Type: " + deviceType
                        font.bold: true
                    }
                }

                Label {
                    text: "Test #" + testNumber
                    font.bold: true
                    color: "blue"
                }

                // Section HAUT
                GroupBox {
                    title: "Contacts HAUT"
                    Layout.fillWidth: true

                    RowLayout {
                        anchors.fill: parent
                        spacing: 10

                        // Contact 1 Haut
                        ColumnLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "Contact 1"
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 30
                                color: highContact1 ? "green" : "red"
                                border.color: "black"
                                border.width: 1
                                radius: 5
                                Label {
                                    anchors.centerIn: parent
                                    text: highContact1 ? "ON" : "OFF"
                                    color: "white"
                                    font.bold: true
                                }
                            }
                        }

                        // Contact 2 Haut
                        ColumnLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "Contact 2"
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 30
                                color: highContact2 ? "green" : "red"
                                border.color: "black"
                                border.width: 1
                                radius: 5
                                Label {
                                    anchors.centerIn: parent
                                    text: highContact2 ? "ON" : "OFF"
                                    color: "white"
                                    font.bold: true
                                }
                            }
                        }

                        // Courant Haut
                        ColumnLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "Courant: " + highCurrent
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 30
                                color: "lightblue"
                                border.color: "black"
                                border.width: 1
                                radius: 5
                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width * Math.min(highCurrent / 1000.0, 1.0)
                                    height: parent.height - 4
                                    color: highCurrent > 500 ? "orange" : "blue"
                                    radius: 3
                                }
                                Label {
                                    anchors.centerIn: parent
                                    text: highCurrent
                                    font.bold: true
                                }
                            }
                        }
                    }
                }

                // Section BAS
                GroupBox {
                    title: "Contacts BAS"
                    Layout.fillWidth: true

                    RowLayout {
                        anchors.fill: parent
                        spacing: 10

                        // Contact 1 Bas
                        ColumnLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "Contact 1"
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 30
                                color: lowContact1 ? "green" : "red"
                                border.color: "black"
                                border.width: 1
                                radius: 5
                                Label {
                                    anchors.centerIn: parent
                                    text: lowContact1 ? "ON" : "OFF"
                                    color: "white"
                                    font.bold: true
                                }
                            }
                        }

                        // Contact 2 Bas
                        ColumnLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "Contact 2"
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 30
                                color: lowContact2 ? "green" : "red"
                                border.color: "black"
                                border.width: 1
                                radius: 5
                                Label {
                                    anchors.centerIn: parent
                                    text: lowContact2 ? "ON" : "OFF"
                                    color: "white"
                                    font.bold: true
                                }
                            }
                        }

                        // Courant Bas
                        ColumnLayout {
                            Layout.fillWidth: true
                            Label {
                                text: "Courant: " + lowCurrent
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Rectangle {
                                Layout.fillWidth: true
                                height: 30
                                color: "lightblue"
                                border.color: "black"
                                border.width: 1
                                radius: 5
                                Rectangle {
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width * Math.min(lowCurrent / 1000.0, 1.0)
                                    height: parent.height - 4
                                    color: lowCurrent > 500 ? "orange" : "blue"
                                    radius: 3
                                }
                                Label {
                                    anchors.centerIn: parent
                                    text: lowCurrent
                                    font.bold: true
                                }
                            }
                        }
                    }
                }
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width
                spacing: 10

                GroupBox {
                    title: "Changement d'ID"
                    Layout.fillWidth: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 10

                        TextField {
                            id: newIdField
                            Layout.fillWidth: true
                            placeholderText: "Nouvel ID (ex: 02)"
                            validator: RegularExpressionValidator { regularExpression: /[0-9a-fA-F]{2}/ }
                        }

                        Button {
                            text: "Changer ID"
                            Layout.fillWidth: true
                            onClicked: {
                                if (globalIdField.text && newIdField.text) {
                                    sendHexa(globalIdField.text + " 07 " + newIdField.text + " 00")
                                }
                            }
                        }

                        Button {
                            text: isTesting ? "Arrêter Test" : "Tester tous les IDs"
                            Layout.fillWidth: true
                            onClicked: {
                                isTesting = !isTesting
                                if (isTesting) {
                                    currentTestId = 0
                                }
                            }
                        }
                    }
                }

                GroupBox {
                    title: "Contrôle Porte et LED"
                    Layout.fillWidth: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 10

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Button {
                                text: "Ouvrir Porte"
                                Layout.fillWidth: true
                                onClicked: {
                                    if (globalIdField.text) {
                                        sendHexa(globalIdField.text + " 0F 03 01")
                                    }
                                }
                            }

                            Button {
                                text: "Fermer Porte"
                                Layout.fillWidth: true
                                onClicked: {
                                    if (globalIdField.text) {
                                        sendHexa(globalIdField.text + " 0F 03 00")
                                    }
                                }
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Button {
                                text: "LED ON"
                                Layout.fillWidth: true
                                onClicked: {
                                    if (globalIdField.text) {
                                        sendHexa(globalIdField.text + " 04 01 01")
                                    }
                                }
                            }

                            Button {
                                text: "LED OFF"
                                Layout.fillWidth: true
                                onClicked: {
                                    if (globalIdField.text) {
                                        sendHexa(globalIdField.text + " 04 01 00")
                                    }
                                }
                            }
                        }
                    }
                }

                GroupBox {
                    title: "Contrôle Temps d'Ouverture"
                    Layout.fillWidth: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 10

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Label {
                                text: "Temps:"
                            }

                            SpinBox {
                                id: doorTimeSpinBox
                                Layout.fillWidth: true
                                from: 1
                                to: 255
                                value: 10
                            }
                        }

                        Button {
                            text: "Ouvrir"
                            Layout.fillWidth: true
                            onClicked: {
                                if (globalIdField.text) {
                                    var timeHex = doorTimeSpinBox.value.toString(16).padStart(2, '0')
                                    sendHexa(globalIdField.text + " 0E 03 " + timeHex)
                                }
                            }
                        }
                    }
                }

                Button {
                    text: "Broadcast check"
                    Layout.fillWidth: true
                    onClicked: {
                        sendHexa("ff 06 00 00")
                    }
                }
            }
        }
    }
}
