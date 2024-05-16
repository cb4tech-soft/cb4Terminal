import QtQuick
import QtQuick.Controls
import "../Style"

Row {
    id:row
    property variant  strData: ['d','e','m','o']

    property string strRichData: "demo"
    property string dateString: ""

    property bool showTime: false
    property bool isSendedData: false
    property int displayMode: 0// 0 = ascii , 1 = hex , 2 = both
    height: textArea.contentHeight +2
    width:parent.width
    function toHex(str) {
        var result = '';
        var j = 0;
        for (var i=0; i<str.length; i++) {
        if (str.charCodeAt(i) < 16)
            result += '0'
        result += str.charCodeAt(i).toString(16)
        result += ' ';
      }
      return result;
    }
    function charToHex(byteChar) {
        var result = '';
        if (byteChar.charCodeAt(0) < 16)
            result += '0'
        result += byteChar.charCodeAt(0).toString(16)
        return result;
    }

    function isPrintable(charByte) {
        return charByte.charCodeAt(0) >= 32 && charByte.charCodeAt(0) <= 126
    }

    function convertDataToMixte(strData) {
        var res = ""
        for (var i = 0; i < strData.length; i++) {
            if (isPrintable(strData[i])) {
                res += strData[i]
            } else {
                res += "<font color=\"lightcoral\">" + charToHex(strData[i]) + "</font>";
            }

        }
        return res
    }

    TextArea{
        id: textArea
        anchors.top: parent.top
        height: textArea.contentHeight + 2
        width: parent.width
        text: {
            var res = ""
            if (isSendedData)
            {
                res += "<font color=\"" + ((Material.theme == Material.Dark) ? "lightblue" : "blue" ) + "\">"
                if (showTime)
                    res += dateString + " : "
                if (displayMode == 0)       // ascii
                    res += strRichData
                else if (displayMode == 1)  // hex
                    res += toHex(strData)
                else                        // both
                {
                    res += convertDataToMixte(strData)
                }
                res += "</font>"
            }
            else
            {
                if (showTime)
                    res += dateString + " : "
                if (displayMode == 0)       // ascii
                    res += strRichData
                else if (displayMode == 1)  // hex
                    res += toHex(strData)
                else                        // both
                {
                    res += convertDataToMixte(strData)
                }
            }
            res
        }

        // text: (isSendedData) ? "<font color=\"" + ((Material.theme == Material.Dark) ? "lightblue" : "blue" ) + "\">" + (((showTime == true)? dateString + " : " : "") + ((hexEnable) ? toHex(strData) : strRichData)) + "</font>"
        //                      :  (((showTime == true)? dateString + " : " : "") + ((hexEnable) ? toHex(strData) : strRichData))

        horizontalAlignment: Text.AlignLeft
        wrapMode: Text.WordWrap
        bottomPadding: 1
        topPadding: 1
        textFormat: Text.RichText
        leftPadding: 5
        selectByMouse: true
        readOnly: true

        Component.onCompleted: {
            strRichData = strData.replace(/\n/g, "<br />")
        }
    }

}
