Serial Terminal Plugin System README
====================================

This document provides an overview and guidance on how to create and manage plugins for the Serial Terminal Plugin System. Each plugin enhances the terminal's capabilities through additional features and integrations.

Contents
--------

*   [Creating a Plugin](#creating-a-plugin)
*   [Base Function](#base-function)
*   [Serial Manager](#serial-manager)
*   [Modules](#modules)
    *   [SoftwareLauncher](#softwarelauncher)
    *   [FileUtils](#fileutils)
    *   [MyScreenInfo](#myscreeninfo)

### Creating a Plugin

To create a new plugin:

1.  Create a new folder within the `plugin` directory.
2.  Inside this folder, add a `.qml` file with the same name as the directory.
3.  Code in QML. Plugins are interpreted and added to the list when the application starts.

`PluginTemplate` is provided as a basic example to demonstrate the fundamental capabilities of a plugin.

### Base Function

The template already includes the property `receiveLineFeatureEnable`, which facilitates the transmission of strings from the serial terminal to the plugin (reception). The frames are retrieved via the `receiveString` function.

Use the `sendString` signal to send a frame to the terminal (sending):


    signal sendString(serialString: string)
    property bool receiveLineFeatureEnable: true
     
    function receiveString(serialString: string) {
        console.log("receiveString: " + serialString)
    }

### Serial Manager

For more comprehensive control over the serial port, it can be accessed via its ID: `serManager`.

Example code to check if it is connected:

    if (!serManager.isConnected) {
         console.log("Serial port Not connected")
         return
    }

For a comprehensive list of properties, refer to the `serialManager.h` file.

### Modules

Modules add functionality to plugins and need to be imported at the beginning of the file:

    import SoftwareLauncher 
    import FileUtils 
    import MyScreenInfo

#### SoftwareLauncher

Launches new programs with:


    SoftwareLauncher.launchSoftware(string exeName, list<string> arguments);  

exemple:
    
    Button {
        text: "Launch"
        onClicked: startProgram("notepad.exe")
    }
     
    property var argumentList: {"demoFile.txt"}
     
    function startProgram(softwarePath: string) {
        SoftwareLauncher.launchSoftware(softwarePath, argumentList)
    }

#### FileUtils

Retrieves information about specific files, disks, or performs file copying:
    
    QStringList getDiskList();
    QStringList getFileInfo(QString filePath);
    QStringList getDriveInfo(QString dirPath);
    bool copyFileToDest(QString file, QString destination);
    
    function updateDisk()
    {
        var driveList = FileUtils.getDiskList()
        for (var i = 0; i < driveList.length; i++) {
            var driveInfo = FileUtils.getDriveInfo(driveList[i])
            driveModel.append({drivePath: driveInfo[0], driveName: driveInfo[1], driveSize: driveInfo[3]})
        }
    }
            

#### MyScreenInfo

Retrieves a QRect containing screen information based on the X and Y parameters passed:
    
    var screenRect = MyScreenInfo.getScreenInfo(root.x, root.y)
    exportView.height = screenRect.height / 2
    exportView.width = screenRect.width / 2
    exportView.x = screenRect.x + screenRect.width / 2 - exportView.width / 2
    exportView.y = screenRect.y + screenRect.height / 2 - exportView.height / 2 
    exportView.show()

This README outlines how to interact with and extend the Serial Terminal Plugin System using QML. Additional details can be found in the specific files and examples provided within the system.
