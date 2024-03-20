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

    radius: 100

    Image {
        id: image
        anchors.centerIn: parent
        source: imgSrc
        height: parent.height*0.9
        width: parent.width*0.9
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
