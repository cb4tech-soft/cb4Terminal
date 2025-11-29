import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import SoftwareLauncher

ApplicationWindow {
    width: 450
    height: 700

    signal sendString(serialString: string)
    signal sendHexa(serialString: string)
    property bool receiveLineFeatureEnable: true

    // Propriétés pour l'envoi des configurations
    property int currentConfigIndex: 0
    property bool isSending: false
    property var configsToSend: []
    property int totalConfigsToSend: 0
    property int successCount: 0
    property string lastResponse: ""

    Timer {
        id: sendTimer
        interval: 300 // 300ms entre chaque commande pour laisser le temps au module de traiter
        repeat: true
        running: isSending
        onTriggered: {
            if (currentConfigIndex < configsToSend.length) {
                var config = configsToSend[currentConfigIndex]
                // Format: ATS'XXX'='YY' + ENTER
                var command = "ATS" + config.register + "=" + config.value + "\r\n"
                sendString(command)
                console.log("Envoi: " + command.trim())
                statusLabel.text = "Envoi: S" + config.register + "=" + config.value
                currentConfigIndex++
            } else {
                // Fin de l'envoi
                isSending = false
                statusLabel.text = "Terminé! " + currentConfigIndex + " configurations envoyées"
                console.log("Envoi terminé!")
            }
        }
    }

    function receiveString(serialString: string) {
        console.log("receiveString: " + serialString.trim())
        lastResponse = serialString.trim()
        
        // Vérifier si c'est un ACK ou une confirmation
        if (serialString.indexOf("OK") !== -1 || serialString.indexOf("ACK") !== -1) {
            successCount++
        }
    }

    function parseConfigs(text) {
        var configs = []
        var lines = text.split(/[\r\n]+/)
        
        for (var i = 0; i < lines.length; i++) {
            var line = lines[i].trim()
            
            // Parser les lignes du type S000=VALUE ou SXXX=VALUE
            var match = line.match(/^S(\d{3})=(.+)$/)
            if (match) {
                var registerNum = match[1]
                var value = match[2].trim()
                
                // Ignorer les valeurs non reçues ou vides
                if (value && value !== "NON_RECU" && value !== "") {
                    configs.push({
                        register: registerNum,
                        value: value
                    })
                }
            }
        }
        
        return configs
    }

    function startSending() {
        if (isSending) return
        
        // Parser le texte d'entrée
        var configs = parseConfigs(inputTextArea.text)
        
        if (configs.length === 0) {
            statusLabel.text = "Aucune configuration valide trouvée!"
            return
        }
        
        // Préparer l'envoi
        configsToSend = configs
        totalConfigsToSend = configs.length
        currentConfigIndex = 0
        successCount = 0
        
        // Afficher le résumé
        console.log("Configurations à envoyer: " + totalConfigsToSend)
        for (var i = 0; i < configs.length; i++) {
            console.log("  S" + configs[i].register + "=" + configs[i].value)
        }
        
        // Démarrer l'envoi
        isSending = true
        statusLabel.text = "Envoi en cours..."
    }

    function stopSending() {
        isSending = false
        statusLabel.text = "Envoi arrêté à " + currentConfigIndex + "/" + totalConfigsToSend
        console.log("Envoi arrêté par l'utilisateur")
    }

    function previewConfigs() {
        var configs = parseConfigs(inputTextArea.text)
        
        if (configs.length === 0) {
            previewTextArea.text = "Aucune configuration valide trouvée.\n\nFormat attendu:\nS000=valeur\nS001=valeur\n..."
            return
        }
        
        var preview = "=== APERÇU DES COMMANDES À ENVOYER ===\n\n"
        preview += "Total: " + configs.length + " configurations\n\n"
        
        for (var i = 0; i < configs.length; i++) {
            var cmd = "ATS" + configs[i].register + "=" + configs[i].value
            preview += (i + 1) + ". " + cmd + "\n"
        }
        
        preview += "\n=== FIN DE L'APERÇU ==="
        previewTextArea.text = preview
    }

    function clearAll() {
        inputTextArea.text = ""
        previewTextArea.text = ""
        configsToSend = []
        currentConfigIndex = 0
        totalConfigsToSend = 0
        statusLabel.text = "Prêt"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 12

        // Titre
        Label {
            text: "ATIM Config Writer"
            font.pixelSize: 20
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }

        Label {
            text: "Envoi de configurations vers le module radio"
            font.pixelSize: 11
            color: "#666666"
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }

        // Zone de saisie du texte de configuration
        GroupBox {
            title: "Configurations à Envoyer (coller le dump ici)"
            Layout.fillWidth: true
            Layout.preferredHeight: 180

            ColumnLayout {
                anchors.fill: parent
                spacing: 8

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    TextArea {
                        id: inputTextArea
                        placeholderText: "Collez ici le texte des configurations...\n\nFormat attendu:\nS000=valeur\nS001=valeur\nS002=valeur\n..."
                        wrapMode: TextArea.Wrap
                        font.family: "Consolas, Monaco, monospace"
                        font.pixelSize: 11
                        selectByMouse: true
                        
                        background: Rectangle {
                            color: "#ffffff"
                            border.color: inputTextArea.activeFocus ? "#0078d4" : "#cccccc"
                            border.width: 1
                            radius: 4
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Button {
                        text: "Aperçu"
                        onClicked: previewConfigs()
                    }

                    Button {
                        text: "Effacer"
                        onClicked: clearAll()
                    }

                    Item { Layout.fillWidth: true }

                    Label {
                        text: {
                            var count = parseConfigs(inputTextArea.text).length
                            return count + " config(s) détectée(s)"
                        }
                        font.pixelSize: 10
                        color: "#666666"
                    }
                }
            }
        }

        // Section de contrôle d'envoi
        GroupBox {
            title: "Contrôle de l'Envoi"
            Layout.fillWidth: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Button {
                        text: isSending ? "⏹ Arrêter" : "▶ Envoyer les Configs"
                        Layout.fillWidth: true
                        highlighted: !isSending
                        onClicked: {
                            if (isSending) {
                                stopSending()
                            } else {
                                startSending()
                            }
                        }
                    }
                }

                // Barre de progression
                ProgressBar {
                    Layout.fillWidth: true
                    from: 0
                    to: totalConfigsToSend > 0 ? totalConfigsToSend : 1
                    value: currentConfigIndex
                    visible: totalConfigsToSend > 0
                }

                // Status
                Label {
                    id: statusLabel
                    text: "Prêt"
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 11
                    color: isSending ? "#0078d4" : "#333333"
                }

                // Délai entre commandes
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Label {
                        text: "Délai entre commandes:"
                        font.pixelSize: 11
                    }

                    SpinBox {
                        id: delaySpinBox
                        from: 100
                        to: 2000
                        stepSize: 50
                        value: 300
                        enabled: !isSending
                        onValueChanged: sendTimer.interval = value

                        textFromValue: function(value) {
                            return value + " ms"
                        }
                    }
                }
            }
        }

        // Aperçu des commandes
        GroupBox {
            title: "Aperçu des Commandes"
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollView {
                anchors.fill: parent
                clip: true

                TextArea {
                    id: previewTextArea
                    readOnly: true
                    selectByMouse: true
                    wrapMode: TextArea.Wrap
                    font.family: "Consolas, Monaco, monospace"
                    font.pixelSize: 11
                    placeholderText: "Cliquez sur 'Aperçu' pour voir les commandes qui seront envoyées..."
                    
                    background: Rectangle {
                        color: "#f8f8f8"
                        border.color: "#cccccc"
                        border.width: 1
                        radius: 4
                    }
                }
            }
        }

        // Info syntaxe
        Rectangle {
            Layout.fillWidth: true
            height: infoLayout.implicitHeight + 16
            color: "#e8f4fd"
            border.color: "#0078d4"
            border.width: 1
            radius: 4

            ColumnLayout {
                id: infoLayout
                anchors.fill: parent
                anchors.margins: 8
                spacing: 2

                Label {
                    text: "ℹ️ Syntaxe d'envoi: ATS'XXX'='YY' + ENTER"
                    font.pixelSize: 10
                    font.bold: true
                    color: "#0078d4"
                }

                Label {
                    text: "XXX = numéro de registre (décimal), YY = valeur (hexa)"
                    font.pixelSize: 9
                    color: "#666666"
                }
            }
        }
    }
}

