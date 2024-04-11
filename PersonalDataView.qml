/*
function: 个人资料视图。
author: zouyujie
date: 2024.4.11
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {

    id: self

    width: 800
    height: 600
    flags: Qt.Window|Qt.FramelessWindowHint  //无边框全套处理
    onYChanged: {
        if (y > Screen.desktopAvailableHeight - 30) {
            self.showMinimized()
        }
    }
    onVisibilityChanged: {
        if (self.visibility === Window.Windowed) {
            self.x = (Screen.desktopAvailableWidth-width)/2
            self.y = (Screen.desktopAvailableHeight-height)/2
        }
    }

    RowLayout {  //信息
        anchors.fill: parent
        spacing: 0

        Item {  //左半边
            Layout.fillHeight: true
            Layout.preferredWidth: self.width/2

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                Item {  //封面
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height*0.7
                    Image {
                        source: "qrc:/image/12.png"
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectCrop
                    }
                }
                Rectangle {  //头像
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height*0.3
                    color: "gray"

                    Item {
                        anchors.centerIn: parent
                        width: parent.width*0.7
                        height: parent.height*0.5
                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {  //头像
                                Layout.fillHeight: true
                                Layout.preferredWidth: parent.width*0.4
                                MyProfileImage {
                                    id: myProfileImage
                                    width: 100
                                    height: 100
                                    anchors.centerIn: parent
                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onEntered: {
                                            myProfileImage.scale = 1.1
                                            cursorShape = Qt.PointingHandCursor
                                        }
                                        onExited: {
                                            myProfileImage.scale = 1
                                        }
                                    }
                                    Behavior on scale {
                                        NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
                                    }
                                }
                            }
                            Item {  //名称
                                Layout.fillHeight: true
                                Layout.preferredWidth: parent.width*0.6

                                Item {
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width
                                    height: 60

                                    Text {
                                        id: userName
                                        width: parent.width
                                        text: "云坠入雾里"
                                        font {
                                            pointSize: 18
                                            family: mFONT_FAMILY
                                            bold: true
                                        }
                                        elide: Qt.ElideRight
                                        color: "#eeffffff"
                                    }
                                    Text {
                                        id: personalSignature
                                        width: parent.width
                                        text: "风吹哪页读哪页......"
                                        anchors.top: userName.bottom
                                        anchors.topMargin: 15
                                        font {
                                            pointSize: 13
                                            family: mFONT_FAMILY
                                        }
                                        elide: Qt.ElideRight
                                        color: "#eeffffff"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        Item {  //右半边
            Layout.fillHeight: true
            Layout.preferredWidth: self.width/2

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 20
                }
                Item {  //中间
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                        }
                        Rectangle {  //qq号
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            color: "red"
                        }
                        Rectangle {  //属相
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            color: "lightblue"
                        }
                        Rectangle {  //等级
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            color: "red"
                        }
                        Rectangle {  //空间
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            color: "lightblue"
                        }
                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            MenuSeparator { width: parent.width; anchors.centerIn: parent }
                        }
                        Rectangle {  //Q龄
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            color: "red"
                        }
                        Rectangle {  //血型
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            color: "lightblue"
                        }
                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            MenuSeparator { width: parent.width; anchors.centerIn: parent }
                        }
                        Rectangle {  //照片墙
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "red"
                        }
                    }
                }  //end 中间
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 20
                }
            }
        }
    }

    ColumnLayout {  //关闭栏
        y: 10
        anchors.fill: parent

        Item {
            y: 10
            Layout.fillWidth: true
            Layout.preferredHeight: 35

            RowLayout {
                anchors.fill: parent
                spacing: 0

                DragHandler {  //跟随移动
                    grabPermissions: PointerHandler.CanTakeOverFromAnything
                    onActiveChanged: if (active) { self.startSystemMove() }
                }

                Item {
                    Layout.preferredWidth: 18
                }
                Item {
                    height: 35
                    width: 40
                    Image {
                        anchors.fill: parent
                        source: "qrc:/image/QQ-01.png"
                        fillMode: Image.PreserveAspectFit
                        scale: 1.5
                        opacity: 0.8
                    }
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                Item{
                    height: 35
                    width: 40
                    MyToolButton {
                        iconSource: "qrc:/image/最小化.png"
                        icon.color: "gray"
                        onClicked: {
                            self.showMinimized()
                        }
                    }
                }
                Item {
                    height: 35
                    width: 40
                    MyToolButton {
                        iconSource: "qrc:/image/关闭.png"
                        icon.color: "gray"
                        onClicked: {
                            self.close()
                        }
                    }
                }
            }
        }
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
