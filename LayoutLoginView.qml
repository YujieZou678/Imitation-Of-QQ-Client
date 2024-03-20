/*
function: 登陆界面。
author: zouyujie
date: 2024.3.19
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

ColumnLayout {
    anchors.fill: parent
    spacing: 0

    Item {  //上半部分
        Layout.preferredHeight: 205
        Layout.fillWidth: true

        Rectangle {
            id: topView
            width: parent.width
            height: 160
            color: "lightblue"
        }

        ProfileImage {
            id: centerView
            width: 100
            height: 100
            anchors {
                top: topView.bottom
                topMargin: -55
                horizontalCenter: parent.horizontalCenter
            }
        }
    }
    Item {  //下半部分
        Layout.fillHeight: true
        Layout.fillWidth: true

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.preferredWidth: 80
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                    Item {
                        Layout.preferredHeight: 35
                        Layout.fillWidth: true
                        Text {
                            text: "注册账号"
                            anchors.centerIn: parent
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    RowLayout {  //账号
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                        }
                        Rectangle {
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 30
                            color: "red"
                        }
                        TextField {  //账号
                            id: accountNumber
                            font {
                                family: window.mFONT_FAMILY
                                pixelSize: 18
                            }
                            background: Rectangle {
                                id: bac
                                implicitHeight: 30
                                implicitWidth: 300
                                color: "#00000000"

                                Shape {
                                    anchors.fill: parent
                                    opacity: 0.1
                                    ShapePath {
                                        strokeWidth: 0
                                        strokeColor: "black"
                                        strokeStyle: ShapePath.SolidLine
                                        startX: -30
                                        startY: bac.height
                                        PathLine {
                                            x: -30; y: bac.height
                                        }
                                        PathLine {
                                            x: bac.width; y: bac.height
                                        }
                                    }
                                }
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {  //密码
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                        }
                        Rectangle {
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 30
                            color: "red"
                        }
                        TextField {  //密码
                            id: passWord
                            font {
                                family: window.mFONT_FAMILY
                                pixelSize: 18
                            }
                            echoMode: TextInput.Password  //密码样式
                            background: Rectangle {
                                id: bac1
                                implicitHeight: 30
                                implicitWidth: 300
                                color: "#00000000"

                                Shape {
                                    anchors.fill: parent
                                    opacity: 0.1
                                    ShapePath {
                                        strokeWidth: 0
                                        strokeColor: "black"
                                        strokeStyle: ShapePath.SolidLine
                                        startX: -30
                                        startY: bac1.height
                                        PathLine {
                                            x: -30; y: bac1.height
                                        }
                                        PathLine {
                                            x: bac1.width; y: bac1.height
                                        }
                                    }
                                }
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {  //自动登陆 记住密码 找回密码
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                        }
                        Item {
                            Layout.preferredWidth: 340
                            Layout.preferredHeight: 15

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                CheckBox {
                                    id: autoLog
                                    text: "自动登陆"
                                }
                                Item {
                                    Layout.fillWidth: true
                                }
                                CheckBox {
                                    id: remmenberPW
                                    text: "记住密码"
                                }

                                Item {
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "找回密码"
                                }
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {  //登陆按钮
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                        }
                        ToolButton {
                            text: "安全登陆"
                            implicitHeight: 40
                            implicitWidth: 200
                            onClicked: {
                                console.log(accountNumber.text)
                                console.log(passWord.text)
                                console.log(autoLog.checked)
                                console.log(remmenberPW.checked)
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            Item {
                Layout.preferredWidth: 80
                Layout.fillHeight: true
            }
        }
    }  // end 下半部分
}  // end ColumnLayout


