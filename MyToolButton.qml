/*
function: 功能按钮, 如：最小化，关闭按钮。
author: zouyujie
date: 2024.3.22
*/
import QtQuick
import QtQuick.Controls

ToolButton {

    property string iconSource: icon.source

    id: self

    anchors.fill: parent
    icon.source: iconSource
    icon.color: "white"
    icon.height: 40
    icon.width: 40
    background: Rectangle {
        color: self.down ? "#f07c82":"#00000000"
    }
}
