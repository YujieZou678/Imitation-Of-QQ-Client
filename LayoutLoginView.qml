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

    property string profileImage: "qrc:/image/12.png"  //头像
    property string accountNumberImage: "qrc:/image/QQ.png"  //账号前的图标
    property string passWordImage: "qrc:/image/bg-lock.png"  //密码前的图标

    function clearView() {  ////清空登陆视图数据
        accountNumber.text = ""
        passWord.text = ""
        checkAccountNumber.visible = false
        checkPassWord.visible = false
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
                            icon.color: "white"
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
                            icon.color: "white"
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
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    centerView.scale = 1.15
                    cursorShape = Qt.PointingHandCursor
                }
                onExited: {
                    centerView.scale = 1
                }
            }
            Behavior on scale {
                NumberAnimation { duration: 300; easing.type: Easing.OutQuad }
            }
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
                            text: "注册账号"
                            anchors.centerIn: parent
                            color: "#848482"
                            font.family: mFONT_FAMILY
                            opacity: 0.7
                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    window.switchRegisterView()
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
                            myText: "账号"
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
                                        if (isExit === "true") {
                                            checkAccountNumber.isRight = true
                                            checkAccountNumber.visible = true
                                        }

                                        onGetReply_CheckAccountNumber.disconnect(onReply)  //断开连接
                                    }
                                    onGetReply_CheckAccountNumber.connect(onReply)  //连接

                                    postRequest(info_CheckAccountNumber(accountNumber.text))
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
                            myText: "密码"
                            myWidth: 220
                            rightExtend: 30
                            echoMode: myShowPasswordImage.showPassWord ? TextInput.Normal:TextInput.Password
                            validator: RegularExpressionValidator {
                                regularExpression: /\w{6,15}/
                            }
                            onTextChanged: {
                                checkPassWord.visible = false
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

                    RowLayout {  //自动登陆 记住密码 找回密码
                        spacing: 0

                        Item {
                            Layout.fillWidth: true
                        }
                        Item {
                            Layout.preferredWidth: 290
                            Layout.preferredHeight: 15

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                CheckBox {
                                    id: autoLog
                                    text: "自动登陆"
                                    contentItem: Text {
                                        text: autoLog.text
                                        font.family: mFONT_FAMILY
                                        color: "#848482"
                                        leftPadding: autoLog.indicator.width + autoLog.spacing
                                        opacity: 0.7
                                    }
                                }
                                Item {
                                    Layout.fillWidth: true
                                }
                                CheckBox {
                                    id: remmenberPW
                                    text: "记住密码"
                                    contentItem: Text {
                                        text: remmenberPW.text
                                        font.family: mFONT_FAMILY
                                        color: "#848482"
                                        leftPadding: remmenberPW.indicator.width + remmenberPW.spacing
                                        opacity: 0.7
                                    }
                                }

                                Item {
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: "找回密码"
                                    color: "#848482"
                                    opacity: 0.7
                                    font.family: mFONT_FAMILY
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
                            id: logButton
                            text: "安全登陆"
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
                                if (!checkAccountNumber.isRight) { checkAccountNumber.prompt(); return }

                                console.log("检测密码......")
                                if (!passWord.acceptableInput) {  //内部检测
                                    console.log("密码错误!");
                                    checkPassWord.isRight = false
                                    checkPassWord.visible = true
                                    checkPassWord.prompt()
                                    return
                                }

                                //服务器检测
                                function onReply(isRight) {  //密码是否正确
                                    if (isRight === "true") {
                                        console.log("登陆成功!")
                                        checkPassWord.isRight = true
                                        switchUserView()
                                    }
                                    else {
                                        console.log("密码错误!");
                                        checkPassWord.isRight = false
                                        checkPassWord.visible = true
                                        checkPassWord.prompt()
                                    }

                                    onGetReply_Login.disconnect(onReply)
                                }
                                onGetReply_Login.connect(onReply)

                                postRequest(info_Login(accountNumber.text, passWord.text))
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
                            id: checkPassWord
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


