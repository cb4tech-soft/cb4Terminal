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

    function receiveString(serialString: string) {
        console.log("receiveString: " + serialString)
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
                                        sendHexa(globalIdField.text + " 0F 01 08")
                                    }
                                }
                            }

                            Button {
                                text: "Fermer Porte"
                                Layout.fillWidth: true
                                onClicked: {
                                    if (globalIdField.text) {
                                        sendHexa(globalIdField.text + " 0F 00 08")
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
