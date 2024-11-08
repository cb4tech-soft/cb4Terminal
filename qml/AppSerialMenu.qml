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

import ComponentCacheManager

MenuBar {
   Menu {
       title: "Advanced"
       ShortcutMenuItem { id: menuItem; text: "New window"; width:implicitBackgroundWidth
            sequence: "Ctrl+Shift+N";
           onTriggered: ComponentCacheManager.createNewInstance()

       }
       ShortcutMenuItem { id: logCopyMenuItem; text: "Log copy view"; width:implicitBackgroundWidth
            sequence: "Ctrl+Shift+L";
           onTriggered: ComponentCacheManager.createLogCopyView(dataViewer.logToText())

       }
       Action { text: "Scan port"; checkable: true; checked:root.scanPortEnable
           onCheckedChanged: function (checked) {
               root.scanPortEnable = checked
               checked = Qt.binding(function() { return root.scanPortEnable })
           }
       }
       Menu {
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

       MenuSeparator{}

       Action { text: "export";
           onTriggered: {
               var screenRect = MyScreenInfo.getScreenInfo(root.x ,  root.y)
               exportView.height = screenRect.height/2
               exportView.width = screenRect.width/2
               exportView.x = screenRect.x + screenRect.width/2 - exportView.width/2
               exportView.y = screenRect.y + screenRect.height/2 - exportView.height/2
               exportView.show()
           }
       }


       MenuSeparator { }

       ShortcutMenuItem { text: "Quit"; width:implicitBackgroundWidth
            sequence: "Ctrl+Q";
           onTriggered: Qt.quit()

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
       Action { text: "Shortcut"
           onTriggered: {shortcutHelp.visible = true}
       }
   }
}
