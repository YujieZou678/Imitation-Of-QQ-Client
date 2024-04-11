/*
function: 个人信息设置视图。
author: zouyujie
date: 2024.4.11
*/
import QtQuick
import QtQuick.Controls

Window {
    width: 600
    height: 400

    onVisibleChanged: {
        if (visible) focus = true
    }
}
