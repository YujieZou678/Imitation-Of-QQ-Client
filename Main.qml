/*
function: 主窗口。
author: zouyujie
date: 2024.3.19
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import QtQuick.Dialogs

ApplicationWindow {
    id: window

    property string mFONT_FAMILY: "微软雅黑"

    /* 各个界面视图声明 */
    property alias layoutLoginView: layoutLoginView  //登陆界面
    property alias layoutRegisterView: layoutRegisterView  //注册界面

    /* 个人数据 */
    property string profileImage: "qrc:/image/12.png"  //头像
    property string id: "2894841947"  //qq号

    width: 520
    height: 400
//    width: 400
//    height: 800
    visible: true

    flags: Qt.Window|Qt.FramelessWindowHint  //无边框全套处理
    onYChanged: {
        if (y > Screen.desktopAvailableHeight - 30) {
            window.showMinimized()
        }
    }
    onVisibilityChanged: {
        if (window.visibility === Window.Windowed) {
            window.x = (Screen.desktopAvailableWidth-width)/2
            window.y = (Screen.desktopAvailableHeight-height)/2
        }
    }

    LayoutLoginView {  //登陆界面
        id: layoutLoginView
        //visible: false
    }

    LayoutRegisterView {  //注册界面
        id: layoutRegisterView
        visible: false
    }

    LayoutUserView {  //登陆成功进入用户界面
        id: layoutUserView
        visible: false
    }

    function switchRegisterView() {  //切换到注册界面
        window.width = 520
        window.height = 460
        window.x = (Screen.desktopAvailableWidth-width)/2
        window.y = (Screen.desktopAvailableHeight-height)/2

        layoutLoginView.visible = false
        layoutRegisterView.clearView()
        layoutRegisterView.visible = true
    }
    function switchLoginView() {  //切换到登陆界面
        window.width = 520
        window.height = 400
        window.x = (Screen.desktopAvailableWidth-width)/2
        window.y = (Screen.desktopAvailableHeight-height)/2

        layoutRegisterView.visible = false
        layoutLoginView.clearView()
        layoutLoginView.visible = true
    }
    function switchUserView() {  //切换到用户界面
        window.width = 400
        window.height = 800
        window.x = (Screen.desktopAvailableWidth-width)/2
        window.y = (Screen.desktopAvailableHeight-height)/2

        layoutLoginView.visible = false
        layoutRegisterView.visible = false
        layoutUserView.visible = true
    }
}
