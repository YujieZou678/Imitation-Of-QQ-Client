/*
function: 注册界面。
author: zouyujie
date: 2024.3.19
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

ColumnLayout {

    property string profileImage: "qrc:/image/12.png"  //头像
    property string accountNumberImage: "qrc:/image/QQ.png"  //账号前的图标
    property string passWordImage: "qrc:/image/bg-lock.png"  //密码前的图标

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

            Item {  //菜单栏
                height: 35
                width: parent.width

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    DragHandler {  //跟随移动
                        grabPermissions: PointerHandler.CanTakeOverFromAnything
                        onActiveChanged: if (active) { window.startSystemMove() }
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
                            onClicked: {
                                window.showMinimized()
                            }
                        }
                    }
                    Item {
                        height: 35
                        width: 40
                        MyToolButton {
                            iconSource: "qrc:/image/关闭.png"
                            onClicked: {
                                Qt.quit()
                            }
                        }
                    }
                }
            }
        }

        MyProfileImage {
            id: centerView
            width: 100
            height: 100
            anchors {
                top: topView.bottom
                topMargin: -55
                horizontalCenter: parent.horizontalCenter
            }
            imgSrc: profileImage
        }
    }
    Item {  //下半部分
        Layout.fillHeight: true
        Layout.fillWidth: true

        RowLayout {
            anchors.fill: parent
            spacing: 0

            Item {  //左一
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
                            text: "登陆账号"
                            anchors.centerIn: parent
                            color: "#848482"
                            font.family: mFONT_FAMILY
                            opacity: 0.7
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    window.switchLoginView()
                                }
                            }
                        }
                    }
                }
            }

            Item {  //左二（中间）
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
                        Item {
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 30
                            Image {
                                anchors.fill: parent
                                source: accountNumberImage
                            }
                        }
                        MyTextField {
                            myText: "注册账号(10个有效数字)"
                            validator: RegularExpressionValidator {
                                regularExpression: /[1-9]\d{9}/
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
                        Item {
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 30
                            Image {
                                anchors.fill: parent
                                source: passWordImage
                                scale: 0.8
                            }
                        }
                        MyTextField {
                            myText: "密码(字母数字最长15个字符)"
                            myWidth: 220
                            rightExtend: 30
                            echoMode: myShowPasswordImage.showPassWord ? TextInput.Normal:TextInput.Password
                            validator: RegularExpressionValidator {
                                regularExpression: /\w{6,15}/
                            }
                        }
                        Item {
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 30
                            MyShowPasswordImage {
                                id: myShowPasswordImage
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {  //再次输入密码
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                        }
                        Item {
                            Layout.preferredHeight: 30
                            Layout.preferredWidth: 30
                            Image {
                                anchors.fill: parent
                                source: passWordImage
                                scale: 0.8
                            }
                        }
                        MyTextField {
                            myText: "再次输入密码"
                            echoMode: TextInput.Password
                            validator: RegularExpressionValidator {
                                regularExpression: /\w{6,15}/
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }

                    RowLayout {  //确认协议
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                        }
                        Item {
                            Layout.preferredWidth: 275
                            Layout.preferredHeight: 15

                            MyRadioButton {
                                id: myRadioButton
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
                            id: logButton
                            text: "立即注册"
                            font {
                                family: mFONT_FAMILY
                                bold: true
                                pixelSize: 15
                            }
                            palette.buttonText: "white"
                            background: Rectangle {
                                anchors.fill: parent
                                color: logButton.down ? "#8fb2c9":"#5698c3"
                                radius: 3
                            }

                            implicitHeight: 40
                            implicitWidth: 280
                            icon.source: "qrc:/image/安全.png"
                            icon.height: 18
                            icon.width: 18
                            icon.color: "#ffffff"

                            onClicked: {
                                if (!myRadioButton.ifSelect) {
                                    myRadioButton.prompt()
                                    return
                                }

                                console.log("检测注册信息......")
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            Item {  //左三
                Layout.preferredWidth: 80
                Layout.fillHeight: true
            }
        }
    }  // end 下半部分
}  // end ColumnLayout


