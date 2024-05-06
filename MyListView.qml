/*
function: 消息模块下的ListView。
author: zouyujie
date: 2024.4.6
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import QtQuick.Layouts

Item {

    property alias repeater: repeater
    property alias listModel: listModel
    property string loaderSource: ""

    function updateAllData() {  //更新所有好友列表
        listModel.clear()    //清空数据
        /* 更新消息列表 */
        for (var i=0; i<main_FriendsList.length; i++) {
            var data = {}
            var accountNumber = main_FriendsList[i].accountNumber//好友账号
            var profileImage = main_FriendsList[i].profileImage  //好友头像
            var nickName = main_FriendsList[i].nickName          //好友昵称
            var msgRow                                           //最后一行消息
            var isMyMsg                                          //是不是自己发的
            var sendMsgNumber                                    //发消息的号码
            var chatHistory = main_FriendsList[i].chatHistory
            if (chatHistory.length < 1) { msgRow = ""; isMyMsg = "true"; sendMsgNumber = main_AccountNumber }
            else {
                var msgList = chatHistory[chatHistory.length-1]
                msgRow = msgList.Msg
                isMyMsg = msgList.IsMyMsg===""? "true":msgList.IsMyMsg
                sendMsgNumber = msgList.SendMsgNumber
            }
            var msgDate = "昨天"                                  //日期

            data.accountNumber = accountNumber  //json数据写法
            data.profileImage = profileImage
            data.nickName = nickName
            data.msgRow = msgRow
            data.isMyMsg = isMyMsg  //没使用
            data.msgDate = msgDate
            data.sendMsgNumber = sendMsgNumber
            data.isNeedCloudChatHistory = true  //默认赋值

            listModel.append(data)
            repeaterModel.append(data)
        }
    }

    function updateOneData(index, oneData) {  //更新一个好友信息视图
        listModel.set(index, oneData)
    }

    function updateOneDataRow(index, row) {  //更新一个好友最后一行聊天记录
        var data = listModel.get(index)
        data.msgRow = row

        listModel.set(index, data)
    }

    anchors.fill: parent

    ListView {
        id: listView
        anchors.fill: parent
        model: ListModel {
            id: listModel
        }

        delegate: listViewDelegate
        highlight: Rectangle {
            opacity: 0.5
            color: "#e2e1e4"
        }
        highlightMoveDuration: 0
        clip: true
    }

    Component {
        id: listViewDelegate
        Rectangle {
            id: listViewDelegateItem
            height: 480/5
            width: listView.width
            color: "#00000000"

            MyShapeLine {  //底线
                lineOpacity: 0.1
                lineStartX: 0
                lineStartY: listViewDelegateItem.height
                lineEndX: window.width
                lineEndY: listViewDelegateItem.height
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    listView.currentIndex = index
                }
                onClicked: {
                    listViewDelegateItem.forceActiveFocus()  //强制获取焦点
                }
                onDoubleClicked: {
                    /* 判断是单个好友还是群聊(9位数字) */
                    if (accountNumber.match(/[1-9]\d{9}/)) {
                        /* 是单个好友 */
                        /* 为聊天窗口赋值 */
                        loaderSource = "MyChatView.qml"
                        var item = repeater.itemAt(index).item
                        item.chatObj = nickName  //好友昵称
                        item.friendAccountNumber = accountNumber  //好友账号

                        if (isNeedCloudChatHistory) {
                            isNeedCloudChatHistory = false  //只执行一次
                            function onReply(chatHistory) {  //获取和该好友的聊天记录
                                for (var i=0; i<main_FriendsList.length; i++) {
                                    if (main_FriendsList[i].accountNumber === accountNumber) {
                                        main_FriendsList[i].chatHistory = chatHistory
                                        break
                                    }
                                }

                                item.updateData()  //刷新所有聊天记录
                                onGetReply_GetChatHistory.disconnect(onReply)  //断开连接
                            }
                            onGetReply_GetChatHistory.connect(onReply)  //连接
                            toServer_GetChatHistory(main_AccountNumber, accountNumber)  //请求
                        }

                        item.visible = true
                        item.raise()  //置顶
                    } else {
                        /* 是群聊 */
                        /* 为群聊天窗口赋值 */
                        loaderSource = "MyGroupChatView.qml"
                        var item = repeater.itemAt(index).item
                        item.groupName = nickName
                        item.groupNumber = accountNumber

                        if (isNeedCloudChatHistory) {
                            isNeedCloudChatHistory = false  //只执行一次
                            /* 获取好友列表 */
                            function onReply(friendList) {
                                for (var i=0; i<friendList.length; i++) {
                                    /* 遍历添加 */
                                    var list = main_FriendsList.filter(item=>item.accountNumber===friendList[i])
                                    if (list.length === 0) {
                                        /* 不是自己好友(需要网络请求) */
                                        var data = {}
                                        data.profileImage = "qrc:/image/profileImage.png"
                                        data.nickName = friendList[i]
                                        item.addFriend(data)
                                    } else {
                                        /* 是自己好友 */
                                        item.addFriend(list[0])
                                    }
                                }
                                onGetReply_GetFriendList.disconnect(onReply)  //断开连接

                                /* 获取聊天记录 */
                                function onGet(chatHistory) {
                                    for (var i=0; i<main_FriendsList.length; i++) {
                                        if (main_FriendsList[i].accountNumber === accountNumber) {
                                            main_FriendsList[i].chatHistory = chatHistory
                                            break
                                        }
                                    }

                                    item.updateData()  //刷新所有聊天记录
                                    onGetReply_GetGroupChatHistory.disconnect(onGet)  //断开连接
                                }
                                onGetReply_GetGroupChatHistory.connect(onGet)  //连接
                                toSubThread_GetGroupChatHistory(accountNumber)
                            }
                            onGetReply_GetFriendList.connect(onReply)  //连接
                            toServer_GetFriendList(accountNumber);
                        }

                        item.visible = true
                        item.raise()  //置顶
                    }
                }
            }

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Item {  //头像
                    Layout.fillHeight: true
                    Layout.preferredWidth: 110

                    MyProfileImage {
                        width: 80
                        height: 80
                        anchors.centerIn: parent
                        imgSrc: profileImage
                        imageHeight: profileImage==="qrc:/image/profileImage.png" ? height*0.75:height
                        imageWidth: profileImage==="qrc:/image/profileImage.png" ? width*0.75:width
                    }
                }
                Item {  //消息介绍/描述
                    Layout.fillHeight: true
                    Layout.preferredWidth: 290

                    Item {
                        width: parent.width
                        height: 60
                        anchors.verticalCenter: parent.verticalCenter

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {  //第一排信息
                                Layout.fillWidth: true
                                Layout.preferredHeight: 40

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 0

                                    Text {
                                        text: nickName
                                        maximumLineCount: 1
                                        font {
                                            pointSize: 14
                                            family: mFONT_FAMILY
                                        }
                                        elide: Text.ElideRight
                                    }
                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        text: msgDate
                                        font {
                                            pointSize: 13
                                            family: mFONT_FAMILY
                                        }
                                        color: "gray"
                                    }
                                    Item {
                                        Layout.preferredWidth: 15
                                    }
                                }
                            }

                            Item {  //第二排信息
                                Layout.fillWidth: true
                                Layout.preferredHeight: 20

                                Text {
                                    width: 280
                                    text: {
                                        if (sendMsgNumber === main_AccountNumber) {
                                            return msgRow
                                        } else {
                                            return nickName+":"+msgRow
                                        }
                                    }

                                    maximumLineCount: 1
                                    font {
                                        pointSize: 11
                                        family: mFONT_FAMILY
                                    }
                                    color: "gray"
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }
            }
        }
    }  //end Component

    Repeater {  //批量生产聊天窗口
        id: repeater
        model: ListModel {
            id: repeaterModel
        }
        Loader {
            source: loaderSource
        }
    }
}
