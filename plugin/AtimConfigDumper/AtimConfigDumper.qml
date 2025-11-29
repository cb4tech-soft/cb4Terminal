import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import SoftwareLauncher

ApplicationWindow {
    width: 400
    height: 600

    signal sendString(serialString: string)
    signal sendHexa(serialString: string)
    property bool receiveLineFeatureEnable: true

    // Propriétés pour le dump des configurations
    property int currentConfigIndex: 0
    property bool isDumping: false
    property var configResults: ({})
    property int totalConfigs: 100
    property string allConfigsText: ""

    Timer {
        id: dumpTimer
        interval: 250 // 250ms entre chaque commande pour laisser le temps au module de répondre
        repeat: true
        running: isDumping
        onTriggered: {
            if (currentConfigIndex < totalConfigs) {
                var configNum = currentConfigIndex.toString().padStart(3, '0')
                var command = "ATS" + configNum + "\r\n"
                sendString(command)
                console.log("Envoi de la commande: " + command.trim())
                currentConfigIndex++
            } else {
                // Fin du dump
                isDumping = false
                currentConfigIndex = 0
                generateAllConfigsText()
                console.log("Dump terminé!")
            }
        }
    }

    function receiveString(serialString: string) {
        console.log("receiveString: " + serialString.trim())
        
        // Parser les réponses du type S[NUMCONFIG]=VALUE\r
        var match = serialString.match(/S(\d{3})=(.+)(?:\r|\n|$)/)
        if (match) {
            var configNum = match[1]
            var configValue = match[2].trim()
            configResults[configNum] = configValue
            console.log("Config reçue: S" + configNum + "=" + configValue)
            
            // Mettre à jour l'affichage en temps réel si souhaité
            if (realTimeUpdateCheckBox.checked) {
                generateAllConfigsText()
            }
        }
    }

    function generateAllConfigsText() {
        var text = "=== DUMP DES CONFIGURATIONS ATIM ===\n\n"
        
        for (var i = 0; i < totalConfigs; i++) {
            var configNum = i.toString().padStart(3, '0')
            var value = configResults[configNum] || "NON_RECU"
            text += "S" + configNum + "=" + value + "\n"
        }
        
        text += "\n=== FIN DU DUMP ===\n"
        text += "Total: " + Object.keys(configResults).length + "/" + totalConfigs + " configurations reçues"
        
        allConfigsText = text
    }

    function startDump() {
        if (isDumping) return
        
        // Reset des données
        configResults = {}
        currentConfigIndex = 0
        allConfigsText = ""
        
        // Démarrer le dump
        isDumping = true
        console.log("Début du dump des configurations...")
    }

    function stopDump() {
        isDumping = false
        currentConfigIndex = 0
        generateAllConfigsText()
        console.log("Dump arrêté par l'utilisateur")
    }

    function clearResults() {
        configResults = {}
        allConfigsText = ""
        currentConfigIndex = 0
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        // Titre
        Label {
            text: "ATIM Config Dumper"
            font.pixelSize: 20
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }

        // Section de contrôle
        GroupBox {
            title: "Contrôle du Dump"
            Layout.fillWidth: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                Button {
                    text: isDumping ? "Arrêter le Dump" : "Démarrer le Dump"
                    Layout.fillWidth: true
                    onClicked: {
                        if (isDumping) {
                            stopDump()
                        } else {
                            startDump()
                        }
                    }
                }

                Button {
                    text: "Effacer les Résultats"
                    Layout.fillWidth: true
                    enabled: !isDumping
                    onClicked: clearResults()
                }

                CheckBox {
                    id: realTimeUpdateCheckBox
                    text: "Mise à jour temps réel"
                    checked: false
                    Layout.fillWidth: true
                }
            }
        }

        // Indicateur de progression
        GroupBox {
            title: "Progression"
            Layout.fillWidth: true
            visible: isDumping || Object.keys(configResults).length > 0

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                ProgressBar {
                    Layout.fillWidth: true
                    from: 0
                    to: totalConfigs
                    value: isDumping ? currentConfigIndex : Object.keys(configResults).length
                }

                Label {
                    text: {
                        if (isDumping) {
                            return "En cours: " + currentConfigIndex + "/" + totalConfigs + 
                                   " (Reçues: " + Object.keys(configResults).length + ")"
                        } else {
                            return "Terminé: " + Object.keys(configResults).length + "/" + totalConfigs + " configurations reçues"
                        }
                    }
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        // Résultats
        GroupBox {
            title: "Résultats des Configurations"
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Button {
                        text: "Tout Sélectionner"
                        onClicked: {
                            resultsTextArea.selectAll()
                        }
                    }

                    Button {
                        text: "Copier"
                        onClicked: {
                            resultsTextArea.selectAll()
                            resultsTextArea.copy()
                        }
                    }

                    Button {
                        text: "Générer Texte Final"
                        enabled: !isDumping && Object.keys(configResults).length > 0
                        onClicked: generateAllConfigsText()
                    }
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    TextArea {
                        id: resultsTextArea
                        text: allConfigsText
                        readOnly: true
                        selectByMouse: true
                        wrapMode: TextArea.Wrap
                        font.family: "Consolas, Monaco, monospace"
                        font.pixelSize: 12
                        
                        background: Rectangle {
                            color: "#f5f5f5"
                            border.color: "#cccccc"
                            border.width: 1
                            radius: 4
                        }
                        
                        placeholderText: (resultsTextArea.text.length) ? "" : "Les résultats du dump apparaîtront ici...\n\nCliquez sur 'Démarrer le Dump' pour commencer."
                    }
                }
            }
        }
    }
}
