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

    function updateData() {
        listModel.clear()  //清空数据
        /* 更新消息列表 */
        for (var i=0; i<main_FriendsList.length; i++) {
            var data = {}
            var accountNumber = main_FriendsList[i].accountNumber//好友账号
            var profileImage = main_FriendsList[i].profileImage  //好友头像
            var nickName = main_FriendsList[i].nickName          //好友昵称
            var msgRow                                           //最后一行消息
            var chatHistory = main_FriendsList[i].chatHistory
            if (chatHistory.length < 1) { msgRow = "" }
            else {
                var msgList = chatHistory[chatHistory.length-1]
                msgRow = msgList.msg
            }
            var msgDate = "昨天"                                  //日期

            data.accountNumber = accountNumber  //json数据写法
            data.profileImage = profileImage
            data.nickName = nickName
            data.msgRow = msgRow
            data.msgDate = msgDate

            listModel.append(data)
            repeaterModel.append(data)
        }
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
                    /* 为聊天窗口赋值 */
                    var item = repeater.itemAt(index).item
                    item.chatObj = nickName  //好友昵称
                    item.friendAccountNumber = accountNumber  //好友账号

                    item.visible = true
                    item.raise()  //置顶
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
                                        font {
                                            pointSize: 14
                                            family: mFONT_FAMILY
                                        }
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
                                    text: msgRow
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
            source: "MyChatView.qml"
        }
    }
}
