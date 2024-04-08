/*
function: 功能按钮, 如：最小化，关闭按钮。
author: zouyujie
date: 2024.3.22
*/
import QtQuick
import QtQuick.Controls

ToolButton {

    property string iconSource: icon.source
    property int iconHeight: 40
    property int iconWidth: 40
    property string clickColor: "#f07c82"
    property real clickOpacity: 1

    id: self

    anchors.fill: parent
    icon.source: iconSource
    icon.height: iconHeight
    icon.width: iconWidth
    background: Rectangle {
        color: self.down ? clickColor:"#00000000"
        opacity: clickOpacity
    }
}
