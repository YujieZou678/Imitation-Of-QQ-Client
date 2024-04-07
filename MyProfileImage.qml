/*
function: 头像图片。
author: zouyujie
date: 2024.3.19
*/
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Rectangle {

    property string imgSrc: "qrc:/image/12.png"
    property bool ifNeedSpacing: true  //是否需要间隙
    property bool ifNeedScale: true    //是否需要放大动态特性

    id: self

    radius: 100
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            if (!ifNeedScale) return
            self.scale = 1.15
            cursorShape = Qt.PointingHandCursor
        }
        onExited: {
            if (!ifNeedScale) return
            self.scale = 1
        }
    }
    Behavior on scale {
        NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
    }

    Image {
        id: image
        anchors.centerIn: parent
        source: imgSrc
        height: ifNeedSpacing ? parent.height*0.93:parent.height
        width: ifNeedSpacing ? parent.width*0.93:parent.width
        fillMode: Image.PreserveAspectCrop  //图像被均匀缩放以填充，必要时进行裁剪
        antialiasing: true  //抗锯齿
        visible: false
    }

    Rectangle{
        id:mask
        color: "black"
        anchors.fill: parent
        radius: 100
        antialiasing: true  //抗锯齿
        visible: false
    }

    OpacityMask{  //mask,处理图片可视范围
        id: realImage
        anchors.fill: image
        source: image
        maskSource: mask
        visible: true  //我们看到的图片，对image进行处理后的，image本身是不可见的
        antialiasing: true  //抗锯齿
    }
}
