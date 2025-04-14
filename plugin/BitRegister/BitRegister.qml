import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    width: 400
    height: 350
    title: "Éditeur de Registre Bits"

    property int registerValue: 0
    property int bitsPerRow: 8  // Affiche 8 bits par ligne

    Rectangle {
        anchors.fill: parent
        color: "#f5f5f5"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 15

        GroupBox {
            title: "Registre (32 bits)"
            Layout.fillWidth: true
            
            ColumnLayout {
                id: bitGrid
                anchors.fill: parent
                spacing: 8
                
                // 4 groupes de 8 bits
                Repeater {
                    model: 4
                    
                    ColumnLayout {
                        id: bitGroup
                        property int groupIndex: index
                        spacing: 2
                        Layout.fillWidth: true
                        
                        // En-tête du groupe
                        Label {
                            text: {
                                const start = 31 - (groupIndex * 8);
                                const end = start - 7;
                                return "Bits " + start + "-" + end;
                            }
                            font.bold: true
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            Layout.fillWidth: true
                        }
                        
                        // Numéros de bits
                        Row {
                            Layout.fillWidth: true
                            spacing: 0
                            
                            Repeater {
                                model: 8
                                
                                Label {
                                    property int bitNum: 31 - (index + groupIndex * 8)
                                    width: 40
                                    text: bitNum.toString()
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: 10
                                }
                            }
                        }
                        
                        // Ligne de cases à cocher
                        Row {
                            Layout.fillWidth: true
                            spacing: 0
                            
                            // Utiliser un Repeater avec un identifiant unique
                            Repeater {
                                id: checkboxRepeater
                                model: 8
                                
                                Item {
                                    id: bitItem
                                    width: 40
                                    height: 30
                                    
                                    // Calculer le numéro de bit
                                    property int bitPosition: index
                                    property int bitIndex: 31 - (bitPosition + (groupIndex * 8))
                                    
                                    // Composant personnalisé pour remplacer CheckBox
                                    Rectangle {
                                        id: customCheckbox
                                        anchors.centerIn: parent
                                        width: 20
                                        height: 20
                                        radius: 3
                                        color: "transparent"
                                        border.color: isChecked ? "#007ACC" : "#777777"
                                        border.width: 1
                                        
                                        // État du bit individuel
                                        property bool isChecked: Boolean(registerValue & (1 << bitIndex))
                                        
                                        Rectangle {
                                            anchors.centerIn: parent
                                            width: 12
                                            height: 12
                                            radius: 2
                                            color: "#007ACC"
                                            visible: customCheckbox.isChecked
                                        }
                                        
                                        // Mise à jour du modèle quand registerValue change
                                        Connections {
                                            target: root
                                            function onRegisterValueChanged() {
                                                customCheckbox.isChecked = Boolean(registerValue & (1 << bitIndex))
                                            }
                                        }
                                    }
                                    
                                    // Zone de clic
                                    MouseArea {
                                        anchors.fill: parent
                                        
                                        onClicked: {
                                            // Inverser l'état de ce bit spécifique
                                            if (customCheckbox.isChecked) {
                                                // Désactiver ce bit
                                                registerValue &= ~(1 << bitIndex)
                                            } else {
                                                // Activer ce bit
                                                registerValue |= (1 << bitIndex)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Séparateur
                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#d0d0d0"
                            visible: groupIndex < 3
                        }
                    }
                }
            }
        }

        // Affichage des valeurs
        GroupBox {
            title: "Valeurs"
            Layout.fillWidth: true
            
            GridLayout {
                anchors.fill: parent
                columns: 3
                
                Label { text: "Hex:" }
                TextField {
                    id: hexValue
                    text: "0x" + (registerValue >>> 0).toString(16).toUpperCase().padStart(8, '0')
                    Layout.fillWidth: true
                    selectByMouse: true
                    onEditingFinished: {
                        let val = text.startsWith("0x") ? text.substring(2) : text
                        if (/^[0-9A-Fa-f]+$/.test(val)) {
                            registerValue = parseInt(val, 16)
                        }
                    }
                }
                Button {
                    text: "Copier"
                    onClicked: {
                        hexValue.selectAll()
                        hexValue.copy()
                    }
                }
                
                Label { text: "Dec:" }
                TextField {
                    id: decValue
                    text: (registerValue >>> 0).toString()
                    Layout.fillWidth: true
                    selectByMouse: true
                    onEditingFinished: {
                        if (/^[0-9]+$/.test(text)) {
                            registerValue = parseInt(text, 10)
                        }
                    }
                }
                Button {
                    text: "Copier"
                    onClicked: {
                        decValue.selectAll()
                        decValue.copy()
                    }
                }
                
                Label { text: "ASCII:" }
                TextField {
                    id: asciiValue
                    text: {
                        // Convertir en caractères si possible
                        try {
                            return String.fromCharCode((registerValue>>>0) & 0xFF + ((registerValue>>>8) & 0xFF) + ((registerValue>>>16) & 0xFF) + ((registerValue>>>24) & 0xFF))
                        } catch (e) {
                            return "N/A"
                        }
                    }
                    Layout.fillWidth: true
                    selectByMouse: true
                }
                Button {
                    text: "Copier"
                    onClicked: {
                        asciiValue.selectAll()
                        asciiValue.copy()
                    }
                }
            }
        }
        
        // Boutons utilitaires
        RowLayout {
            Layout.fillWidth: true
            
            Button {
                text: "Tout à 0"
                onClicked: registerValue = 0
                Layout.fillWidth: true
            }
            
            Button {
                text: "Tout à 1"
                onClicked: registerValue = 0xFFFFFFFF
                Layout.fillWidth: true
            }
            
            Button {
                text: "Inverser Tout"
                onClicked: registerValue = ~registerValue
                Layout.fillWidth: true
            }
            
            Button {
                text: "Déc. Gauche"
                onClicked: registerValue = (registerValue << 1) >>> 0
                Layout.fillWidth: true
            }
            
            Button {
                text: "Déc. Droite"
                onClicked: registerValue = (registerValue >>> 1)
                Layout.fillWidth: true
            }
        }
    }
}
