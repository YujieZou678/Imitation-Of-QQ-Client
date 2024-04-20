/*
function: 消息记录, ListView。
author: zouyujie
date: 2024.4.20
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {

    anchors.fill: parent
    property var messageList: []  //消息列表
    onMessageListChanged: {
        /* 初始化消息列表 */
        var data = {}
        data.isMyMsg = true  //是否是本人发的消息
        data.msg = "123"

        var data1 = {}
        data1.isMyMsg = false  //是否是本人发的消息
        data1.msg = "123"

        listModel.append(data)
        listModel.append(data1)
    }

    ListView {
        id: listView
        anchors.fill: parent
        model: ListModel {
            id: listModel
        }
        delegate: listViewDelegate
        clip: true
        ScrollBar.vertical: ScrollBar {
            anchors.right: parent.right
            Component.onCompleted: {
                position = 1
            }
        }
    }

    Component {  //一条消息
        id: listViewDelegate
        Item {
            id: listViewDelegateItem
            height: 70  //会变化
            width: listView.width

            RowLayout {
                anchors.fill: parent
                spacing: 0
                /* 非本人发的消息 */
                Item {  //头像
                    Layout.fillHeight: true
                    Layout.preferredWidth: 70
                    visible: !isMyMsg
                    MyProfileImage {
                        anchors.fill: parent
                        imgSrc: main_ProfileImage
                        imageHeight: 50
                        imageWidth: 50
                        imgRadius: parent.width
                    }
                }
                Item {  //消息
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    visible: !isMyMsg

                    Rectangle {  //消息
                        width: myText1.width+25
                        height: myText1.height+25
                        color: "lightblue"
                        radius: 5
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        Text {
                            id: myText1
                            anchors.centerIn: parent
                            text: msg
                            font {
                                family: mFONT_FAMILY
                                pointSize: 12
                            }
                        }
                    }
                }

                /* 本人发的消息 */
                Item {  //消息
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    visible: isMyMsg

                    Rectangle {  //消息
                        width: myText2.width+25
                        height: myText2.height+25
                        color: "lightblue"
                        radius: 5
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        Text {
                            id: myText2
                            anchors.centerIn: parent
                            text: msg
                            font {
                                family: mFONT_FAMILY
                                pointSize: 12
                            }
                        }
                    }
                }
                Item {  //头像
                    Layout.fillHeight: true
                    Layout.preferredWidth: 70
                    visible: isMyMsg
                    MyProfileImage {
                        anchors.fill: parent
                        imgSrc: main_ProfileImage
                        imageHeight: 50
                        imageWidth: 50
                        imgRadius: parent.width
                    }
                }
            }
        }
    }
}
