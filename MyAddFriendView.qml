/*
function: 加好友窗口。
author: zouyujie
date: 2024.4.21
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: self
    width: 400
    height: 450
    flags: Qt.Window|Qt.FramelessWindowHint  //无边框全套处理

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {  //拖动栏
            Layout.fillWidth: true
            Layout.preferredHeight: 35
            color: "lightblue"

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
                Item { width: 22 }
                Item {  //聊天对象
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Text {
                        id: objText
                        anchors.centerIn: parent
                        text: "加好友/群"
                        font {
                            family: mFONT_FAMILY
                            pointSize: 13
                        }
                        //color: "#eeffffff"
                    }
                }
                Item{
                    height: 35
                    width: 40
                    MyToolButton {
                        iconSource: "qrc:/image/最小化.png"
                        icon.color: "white"
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
                        icon.color: "white"
                        onClicked: {
                            self.close()
                        }
                    }
                }
            }
        }
        Item {  //搜索框
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            Item {
                width: parent.width*0.9
                height: 50
                anchors.centerIn: parent

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "lightgray"
                        opacity: 0.6
                        radius: 5

                        RowLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {  //搜索图标
                                Layout.fillHeight: true
                                Layout.preferredWidth: 40
                                Image {
                                    source: "qrc:/image/搜索.png"
                                    width: 20
                                    height: 20
                                    anchors.centerIn: parent
                                }
                            }
                            Item {  //输入框
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                TextField {
                                    id: textField
                                    anchors.fill: parent
                                    background: Rectangle {
                                        color: "#00000000"
                                    }
                                    font {
                                        family: mFONT_FAMILY
                                        pointSize: 14
                                    }
                                    onTextChanged: {
                                        if (text === "") {
                                            clearIcon.visible = false
                                            return
                                        }
                                        clearIcon.visible = true
                                    }
                                }
                            }
                            Item {  //清空图标
                                Layout.fillHeight: true
                                Layout.preferredWidth: 40
                                MyToolButton {
                                    id: clearIcon
                                    visible: false
                                    iconSource: "qrc:/image/关闭.png"
                                    clickColor: "#00000000"
                                    icon.color: "gray"
                                    iconHeight: 20
                                    iconWidth: 20
                                    MouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onEntered: {
                                            cursorShape = Qt.PointingHandCursor
                                        }
                                        onExited: {
                                            cursorShape = Qt.ArrowCursor
                                        }
                                        onClicked: {
                                            textField.clear()
                                            textField.focus = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Item {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 10
                    }
                    Item {  //搜索按钮
                        Layout.fillHeight: true
                        Layout.preferredWidth: 80
                        MyToolButton {
                            text: "搜索"
                            font {
                                family: mFONT_FAMILY
                                pointSize: 13
                            }
                            bacColor: "#baccd9"
                            clickColor: "#93b5cf"
                            bacRadius: 5
                            clickOpacity: 0.6
                        }
                    }
                }
            }
        }
        Item {  //查找人
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width*0.05
                }
                Item {  //查找人
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ColumnLayout {  //查找人
                        anchors.fill: parent
                        spacing: 0

                        Item {  //查找人
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            Text {
                                text: "查找人"
                                anchors.verticalCenter: parent.verticalCenter
                                font {
                                    family: mFONT_FAMILY
                                    pointSize: 12
                                }
                                color: "gray"
                            }
                        }
                        Item {  //listView
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            ListView {
                                id: listView
                                anchors.fill: parent
                                model: 1
                                clip: true
                                delegate: Item {
                                    height: 100
                                    width: parent.width
                                    RowLayout {
                                        anchors.fill: parent
                                        spacing: 0
                                        Rectangle {
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: parent.height
                                            //color: "red"
                                            MyProfileImage {
                                                imgSrc: main_ProfileImage
                                                width: 80
                                                height: 80
                                                imageHeight: 80
                                                imageWidth: 80
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }
                                        Rectangle {  //查找人信息
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            //color: "red"
                                            ColumnLayout {
                                                anchors.fill: parent
                                                spacing: 0
                                                Item {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 15
                                                }
                                                Rectangle {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 30
                                                    Text {
                                                        text: main_NickName
                                                        font {
                                                            family: mFONT_FAMILY
                                                            pointSize: 14
                                                        }
                                                        anchors.verticalCenter: parent.verticalCenter
                                                    }
                                                }
                                                Item {
                                                    Layout.fillWidth: true
                                                    Layout.fillHeight: true
                                                }
                                                Rectangle {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 20
                                                    Text {
                                                        text: main_AccountNumber
                                                        font {
                                                            family: mFONT_FAMILY
                                                            pointSize: 11
                                                        }
                                                        color: "lightblue"
                                                        anchors.verticalCenter: parent.verticalCenter
                                                    }
                                                }
                                                Item {
                                                    Layout.fillWidth: true
                                                    Layout.preferredHeight: 25
                                                }
                                            }
                                        }
                                        Item {
                                            Layout.fillHeight: true
                                            Layout.preferredWidth: 100
                                            Item {
                                                height: 30
                                                width: 80
                                                anchors.centerIn: parent
                                                MyToolButton {
                                                    text: "加好友"  //需要判断是不是好友
                                                    borderWidth: 1
                                                    bacRadius: 5
                                                    clickColor: "#e2e1e4"
                                                    clickOpacity: 0.8
                                                }
                                            }
                                        }
                                    }
                                    MenuSeparator { width: parent.width; padding: 0; anchors.bottom: parent.bottom }
                                }  //end Delegate
                            }
                        }
                    }
                }
                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: parent.width*0.05
                }
            }
        }
    }
}
