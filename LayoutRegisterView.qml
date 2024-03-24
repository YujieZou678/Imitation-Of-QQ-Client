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

    function clearView() {  //清空注册视图数据
        accountNumber.text = ""
        passWord.text = ""
        passWordAgain.text = ""
        checkAccountNumber.visible = false
        checkPassWord1.visible = false
        checkPassWord2.visible = false
        myRadioButton.ifSelect = false
    }

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
                            id: accountNumber
                            myText: "注册账号(10个有效数字)"
                            validator: RegularExpressionValidator {
                                regularExpression: /[1-9]\d{9}/
                            }
                            onTextChanged: {
                                if (!acceptableInput) {
                                    checkAccountNumber.isRight = false
                                    checkAccountNumber.visible = true
                                }
                                else {
                                    console.log("账号发送到服务器检测......")
                                    function onReply(isExit) {  //参数：账号是否已经存在
                                        if (isExit === "false") {
                                            checkAccountNumber.isRight = true
                                            checkAccountNumber.visible = true
                                        }

                                        onGetReply.disconnect(onReply)  //断开连接
                                    }
                                    onGetReply.connect(onReply)  //连接

                                    postRequest(toJson_CheckAccountNumber(accountNumber.text))
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
                            id: passWord
                            myText: "密码(字母数字最长15个字符)"
                            myWidth: 220
                            rightExtend: 30
                            echoMode: myShowPasswordImage.showPassWord ? TextInput.Normal:TextInput.Password
                            validator: RegularExpressionValidator {
                                regularExpression: /\w{6,15}/
                            }
                            onTextChanged: {
                                if (!acceptableInput) {
                                    checkPassWord1.isRight = false
                                    checkPassWord1.visible = true
                                }
                                else {
                                    checkPassWord1.isRight = true
                                    checkPassWord1.visible = true
                                }
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
                            id: passWordAgain
                            myText: "再次输入密码"
                            echoMode: TextInput.Password
                            validator: RegularExpressionValidator {
                                regularExpression: /\w{6,15}/
                            }
                            onTextChanged: {
                                if (passWord.text !== passWordAgain.text) {
                                    checkPassWord2.isRight = false
                                    checkPassWord2.visible = true
                                }
                                else {
                                    checkPassWord2.isRight = true
                                    checkPassWord2.visible = true
                                }
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
                                checkAccountNumber.visible = true
                                checkPassWord1.visible = true
                                checkPassWord2.visible = true

                                if (!checkAccountNumber.isRight) { checkAccountNumber.prompt() }
                                if (!checkPassWord1.isRight) { checkPassWord1.prompt() }
                                if (!checkPassWord2.isRight) { checkPassWord2.prompt() }
                                if (!myRadioButton.ifSelect) { myRadioButton.prompt() }

                                if (!checkAccountNumber.isRight|!checkPassWord1.isRight|!checkPassWord2.isRight|!myRadioButton.ifSelect) return

                                console.log("注册成功。")
                                switchLoginView()

//                                var data = {
//                                    accountNumber: accountNumber.text,
//                                    passWord: passWord.text
//                                }
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

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: 30
                        MyCheckImage {
                            id: checkAccountNumber
                        }
                    }
                    Item {
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: 30
                        MyCheckImage {
                            id: checkPassWord1
                        }
                    }
                    Item {
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: 30
                        MyCheckImage {
                            id: checkPassWord2
                        }
                    }
                    Item {
                        Layout.preferredHeight: 45
                    }
                }
            }
        }
    }  // end 下半部分
}  // end ColumnLayout


