//RunHorseText.qml
import QtQuick
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
Item {
    id: rootWidget
//    width: 1080
//    height: 100

//    Text {
//        id: linearLabel
//        font.bold: true
//        font.pixelSize: 50
//        color: "red"
//        font.family: "微软雅黑"
//        text: "You are welcome!"
//        z:1
//    }

    LinearGradient {
        id: temp
        anchors.fill: parent
        start: Qt.point(0, parent.height/2)
        end: Qt.point(parent.width, parent.height/2)
        gradient: Gradient {
            //position可以更改线性透明的位置， color 就是字体的颜色(两边应该是透明的)
            //这里是字体后面背景
            GradientStop { position: 0.0; color: Qt.rgba(255,255,255,0.1) }
            GradientStop { position: 0.3; color: "blue" }
            GradientStop { position: 0.7; color: "blue" }
            GradientStop { position: 1.0; color: Qt.rgba(255,255,255,0.1) }
        }
    }

    PathAnimation{
        id: pathTextMove
        target: temp
        //动画的持续时间
        duration: 6000
        //动画持续的次数
        loops: 2000
        orientationEntryDuration: 0;
        orientationExitDuration:  0;
        orientation: PathAnimation.LeftFirst
        path:Path{
            startX: 0
            startY: rootWidget.height
            PathLine{
                x: 0 - temp.width
                y: rootWidget.height/2 - temp.height/2
            }
        }
        running: true
    }
}
