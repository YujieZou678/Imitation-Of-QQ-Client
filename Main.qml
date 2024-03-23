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

    width: 520
    height: 400
    //height: 460
    visible: true
    title: qsTr("登陆&注册")

    flags: Qt.Window|Qt.FramelessWindowHint  //无边框全套处理
    property int bw: 3
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
    // The mouse area is just for setting the right cursor shape
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: {
            const p = Qt.point(mouseX, mouseY);
            const b = bw + 10; // Increase the corner size slightly
            if (p.x < b && p.y < b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y >= height - b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y < b) return Qt.SizeBDiagCursor;
            if (p.x < b && p.y >= height - b) return Qt.SizeBDiagCursor;
            if (p.x < b || p.x >= width - b) return Qt.SizeHorCursor;
            if (p.y >= height - b) return Qt.SizeVerCursor;
        }
        acceptedButtons: Qt.NoButton // don't handle actual events
    }
    DragHandler {
        id: resizeHandler
        grabPermissions: TapHandler.TakeOverForbidden
        target: null
        onActiveChanged: if (active) {
                             const p = resizeHandler.centroid.position;
                             const b = bw + 10; // Increase the corner size slightly
                             let e = 0;
                             if (p.x < b) { e = Qt.LeftEdge }
                             if (p.x >= width - b) { e = Qt.RightEdge }
                             if (p.y < b) { e = Qt.TopEdge }
                             if (p.y >= height - b) { e = Qt.BottomEdge }
                             window.startSystemResize(e);
                         }
    }

    LayoutLoginView {  //登陆界面
        id: layoutLoginView
    }

    LayoutRegisterView {
        id: layoutRegisterView
        visible: false
    }

//    Test {
//        anchors.fill: parent
//    }

    function switchRegisterView() {  //切换到注册界面
        window.width = 520
        window.height = 460
        window.x = (Screen.desktopAvailableWidth-width)/2
        window.y = (Screen.desktopAvailableHeight-height)/2

        layoutLoginView.visible = false
        layoutRegisterView.visible = true
    }
    function switchLoginView() {  //切换到登陆界面
        window.width = 520
        window.height = 400
        window.x = (Screen.desktopAvailableWidth-width)/2
        window.y = (Screen.desktopAvailableHeight-height)/2

        layoutRegisterView.visible = false
        layoutLoginView.visible = true
    }
}
