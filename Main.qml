/*
function: 主窗口。
author: zouyujie
date: 2024.3.19
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window

    property string mFONT_FAMILY: "微软雅黑"

    width: 520
    height: 400
    visible: true
    title: qsTr("登陆&注册")

    LayoutLoginView {  //登陆界面
        id: layoutLoginView
    }
}
