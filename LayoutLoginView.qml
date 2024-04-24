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

    property string accountNumberImage: "qrc:/image/QQ.png"  //账号前的图标
    property string passWordImage: "qrc:/image/bg-lock.png"  //密码前的图标
    property int loadIndex: 0  //加载好友具体信息index

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
            imgSrc: main_ProfileImage
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

                                    main_ProfileImage = "qrc:/image/profileImage.png"
                                }
                                else {
                                    main_AccountNumber = accountNumber.text  //改变id
                                    console.log("账号发送到服务器检测......")
                                    function onReply(isExit) {  //检测账号
                                        if (isExit === "true") {
                                            checkAccountNumber.isRight = true
                                            checkAccountNumber.visible = true
                                        }

                                        onGetReply_CheckAccountNumber.disconnect(onReply)  //断开连接
                                    }
                                    function onFinished(nickName, isReceive) {  //收到图像文件
                                        main_ProfileImage = isReceive? "file:///root/my_test/Client/build/config/profileImage/"+main_AccountNumber+".png":main_ProfileImage
                                        centerView.imageHeight = centerView.height*0.93
                                        centerView.imageWidth = centerView.width*0.93
                                        onFinished_ReceiveFile.disconnect(onFinished)  //断开连接
                                    }
                                    onGetReply_CheckAccountNumber.connect(onReply)  //连接
                                    onFinished_ReceiveFile.connect(onFinished)      //连接

                                    toServer_CheckAccountNumber(accountNumber.text, "Login")  //请求验证账号
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

                                /* 服务器检测 */
                                function onReply(isRight) {  //密码是否正确
                                    if (isRight === "true") {
                                        console.log("登陆成功!")
                                        checkPassWord.isRight = true
                                        main_AccountNumber = accountNumber.text
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
                                function onGet(doc) {  //收到个人信息+好友列表 json数据
                                    /* 初始化个人信息 */
                                    console.log("初始化个人信息")
                                    if (doc.NickName !== "") {
                                        main_NickName = doc.NickName
                                    }
                                    if (doc.Sex !== "") {
                                        main_Sex = doc.Sex
                                    }
                                    if (doc.ZodiacSign !== "") {
                                        main_ZodiacSign = doc.ZodiacSign
                                    }
                                    if (doc.BloodGroup !== "") {
                                        main_BloodGroup = doc.BloodGroup
                                    }
                                    if (doc.PersonalSignature !== "") {
                                        main_PersonalSignature = doc.PersonalSignature
                                    }
                                    /* 初始化好友列表 */
                                    console.log("初始化好友列表")
                                    var friendArray = doc.FriendArray
                                    for (var i=0; i<friendArray.length; i++) {
                                        var data = {}
                                        data.accountNumber = friendArray[i]
                                        data.nickName = friendArray[i]
                                        data.profileImage = "qrc:/image/profileImage.png"  //默认赋值
                                        data.chatHistory = []  //默认赋值
                                        main_FriendsList.push(data)
                                        updateFriendListView() //更新视图
                                    }
                                    /* 请求加载好友列表具体信息 头像+昵称 */
                                    console.log("开始加载好友列表具体信息...")
                                    requestFriendData()  //递归请求（头像+昵称）
                                    /* 加载聊天记录最后一行 */
                                    for (var i=0; i<main_FriendsList.length; i++) {
                                        var friendAccountNumber = main_FriendsList[i].accountNumber
                                        var data = {}
                                        var msgLocalCache = getLocalCache_ChatHistory(accountNumber.text, friendAccountNumber)
                                        data.Msg = msgLocalCache.Msg===undefined? "":msgLocalCache.Msg
                                        data.IsMyMsg = msgLocalCache.IsMyMsg===undefined? "":msgLocalCache.IsMyMsg
                                        main_FriendsList[i].chatHistory = []
                                        main_FriendsList[i].chatHistory.push(data)
                                        updateFriendListView()  //更新视图
                                    }

                                    onGetReply_GetPersonalData.disconnect(onGet)  //断开连接
                                }
                                onGetReply_GetPersonalData.connect(onGet) //连接
                                onGetReply_Login.connect(onReply)         //连接

                                toServer_Login(accountNumber.text, passWord.text)  //请求登陆验证
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

    function requestFriendData() {
        /* 当前加载好友账号 */
        var accountNumber = main_FriendsList[loadIndex].accountNumber

        function onFinished(nickName, isReceive) {  //昵称 是否接收了头像
            loadIndex = loadIndex+1
            if (loadIndex < main_FriendsList.length) {  //终止条件
                requestFriendData()  //递归
            }
            /* 赋值 */
            console.log("好友"+loadIndex+" "+accountNumber+"具体信息加载完毕")
            main_FriendsList[loadIndex-1].nickName = nickName===""? "未知昵称":nickName
            main_FriendsList[loadIndex-1].profileImage = isReceive? "file:///root/my_test/Client/build/config/profileImage/"+accountNumber+".png":"qrc:/image/profileImage.png"

            updateFriendListView()  //更新视图

            onFinished_ReceiveFile.disconnect(onFinished)  //连接
        }
        onFinished_ReceiveFile.connect(onFinished)  //连接

        toServer_RequestGetProfileAndName(accountNumber)
    }
}  // end ColumnLayout

