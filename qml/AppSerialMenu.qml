import QtQuick
import QtQuick.Controls


import QtQuick.Layouts
import SerialManager
import QtQuick.Window
import Qt.labs.platform as Platform


import "SerialManagerTools" as SerialTool
import MyScreenInfo

import PluginInfo

import 'qrc:/js/fileStringTools.js' as FileStringTools


MenuBar {
   Menu {
       title: "Advanced"
       Action { text: "Scan port"; checkable: true; checked:root.scanPortEnable
           onCheckedChanged: function (checked) {
               root.scanPortEnable = checked
               checked = Qt.binding(function() { return root.scanPortEnable })
           }

       }
       Menu{
           title: "Notification"
           Action { text: "Desktop"; checkable: true; checked:root.sysTrayPopupEnable
               enabled: root.scanPortEnable
               onCheckedChanged: function (checked) {
                   root.sysTrayPopupEnable = checked
                   checked = Qt.binding(function() { return root.sysTrayPopupEnable })
               }
           }
           Action { text: "Popup"; checkable: true; checked:root.comPopupEnable
               enabled: root.scanPortEnable
               onCheckedChanged: function (checked) {
                   root.comPopupEnable = checked
                   checked = Qt.binding(function() { return root.comPopupEnable })
               }
           }
       }


       MenuSeparator{}
       Action { text: "ClearOnSend"; checkable: true; checked:root.clearOnSend
           onCheckedChanged: function (checked) {
               root.clearOnSend = checked
               checked = Qt.binding(function() { return root.clearOnSend })
           }
       }
       MenuSeparator { }
       Action { text: qsTr("&Quit")
                onTriggered: Qt.quit()
       }
   }
   Menu {
       title: "Addon"
       Action {
           text: "Heatmap"
           onTriggered: {
                console.log("opening heatmap")
                heatmapLoader.source = "Heatmap.qml"
                heatmapLoader.active = true
                heatmapLoader.item.visible = true
                var posX = root.x + root.width
                var posY = root.y
                var screenRect = MyScreenInfo.getScreenInfo( root.x ,  root.y)
                if (posX + heatmapLoader.item.width >= screenRect.x + screenRect.width - 50)
                {
                   console.log("update windows pos ", posX + heatmapLoader.item.width)
                   posX = screenRect.x + screenRect.width - heatmapLoader.item.width - 50
                }
                if (posY + heatmapLoader.item.height >= screenRect.y + screenRect.height - 50)
                {
                   posY = screenRect.y + screenRect.height - heatmapLoader.item.height-50
                }

                console.log("windows pos = ", posX)
                heatmapLoader.item.x = posX
                heatmapLoader.item.y = posY
           }
       }
       Action {
           text: "CustomButton"
           onTriggered: {
                console.log("opening CustomButtonWindow.qml")
                customButton.source = "CustomButtonWindow.qml"
                customButton.active = true
                customButton.item.visible = true
                var posX = root.x
                var posY = root.y + root.height
                var screenRect = MyScreenInfo.getScreenInfo( root.x ,  root.y)
                if (posX + customButton.item.width >= screenRect.x + screenRect.width - 50)
                {
                   console.log("update windows pos ", posX + customButton.item.width)
                   posX = screenRect.x + screenRect.width - customButton.item.width - 50
                }
                if (posY + customButton.item.height >= screenRect.y + screenRect.height - 50)
                {
                   posY = screenRect.y + screenRect.height - customButton.item.height-50
                }

                console.log("windows pos = ", posX)
                customButton.item.x = posX
                customButton.item.y = posY

           }
       }
   }
   Menu {
        title: "Plugin"
        id: pluginMenu
        Instantiator {
            model: PluginInfo.pluginFiles

            MenuItem {
                text: FileStringTools.getFileNameFromPath(modelData)
                onTriggered: {
                    pluginLoader.itemAt(index).source = "file:/" + modelData + "?"+Math.random()    // force reload
                    pluginLoader.itemAt(index).active = true
                    pluginLoader.itemAt(index).item.visible = true
                    var posX = root.x + root.width
                    var posY = root.y + root.height
                    var screenRect = MyScreenInfo.getScreenInfo( root.x ,  root.y)
                    if (posX + pluginLoader.itemAt(index).item.width >= screenRect.x + screenRect.width - 50)
                    {
                       posX = screenRect.x + screenRect.width - pluginLoader.itemAt(index).item.width - 50
                    }
                    if (posY + pluginLoader.itemAt(index).item.height >= screenRect.y + screenRect.height - 50)
                    {
                       posY = screenRect.y + screenRect.height - pluginLoader.itemAt(index).item.height-50
                    }

                    pluginLoader.itemAt(index).item.x = posX
                    pluginLoader.itemAt(index).item.y = posY
                }
            }
            onObjectAdded:(index, object) => pluginMenu.insertItem(index, object)
            onObjectRemoved: (index, object) => pluginMenu.removeItem(object)
        }
   }
   Menu {
       title: "Help"
       Action { text: "Donation"
           onTriggered: {donation.visible = true; donation.catIndex = Math.ceil(Math.random() * 19)}
       }
   }
}
