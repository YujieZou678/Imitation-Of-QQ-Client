/*
function: 输入框。
author: zouyujie
date: 2024.3.23
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes

TextField {

    property string myText: "这个人很懒......"  //提示语

    id: accountNumber
    placeholderText: myText
    placeholderTextColor: "#b2bbbe"

    font {
        family: window.mFONT_FAMILY
        pixelSize: 18
    }
    background: Rectangle {
        id: bac
        implicitHeight: 30
        implicitWidth: 250
        color: "#00000000"

        Shape {
            anchors.fill: parent
            opacity: 0.1
            ShapePath {
                strokeWidth: 0
                strokeColor: "black"
                strokeStyle: ShapePath.SolidLine
                startX: -30
                startY: bac.height+5
                PathLine {
                    x: -30; y: bac.height+5
                }
                PathLine {
                    x: bac.width; y: bac.height+5
                }
            }
        }
    }
}
