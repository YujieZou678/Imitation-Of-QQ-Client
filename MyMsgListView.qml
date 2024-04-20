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
        data.msg = "一声渺远却嘹亮的鸡啼中，熟睡的小镇打个哈欠，揉揉惺忪的睡眼，渐渐地苏醒过来。小镇繁忙而又安适的一天开始了！我背上书包，蹑手蹑脚地下楼，生怕吵醒了仍在熟睡中的邻居们。
楼下阿婆依旧在烧她的煤炉。阿婆用蒲扇轻"

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
        Rectangle {
            id: listViewDelegateItem
            Text {  //提前获取消息的高度
                id: testText
                visible: false
                text: msg
                font.pointSize: 12
                wrapMode: Text.WrapAnywhere
                lineHeight: 1.4
                width: 500  //设置最长宽度
            }

            height: testText.contentHeight+50  //弹性变化
            width: listView.width
            //color: "red"

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
                        height: testText.contentHeight+10
                        width: testText.contentWidth+25
                        color: "lightblue"
                        radius: 5
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {
                                Layout.preferredHeight: 11
                                Layout.fillWidth: true
                            }
                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Text {
                                    anchors.centerIn: parent
                                    text: msg
                                    font {
                                        family: mFONT_FAMILY
                                        pointSize: 12
                                    }
                                    wrapMode: Text.Wrap
                                    lineHeight: 1.4
                                    width: testText.contentWidth
                                }
                            }
                            Item {
                                Layout.preferredHeight: 5
                                Layout.fillWidth: true
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
                        height: testText.contentHeight+10
                        width: testText.contentWidth+25
                        color: "lightblue"
                        radius: 5
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 0

                            Item {
                                Layout.preferredHeight: 11
                                Layout.fillWidth: true
                            }
                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Text {
                                    anchors.centerIn: parent
                                    text: msg
                                    font {
                                        family: mFONT_FAMILY
                                        pointSize: 12
                                    }
                                    wrapMode: Text.Wrap
                                    lineHeight: 1.4
                                    width: testText.contentWidth
                                }
                            }
                            Item {
                                Layout.preferredHeight: 5
                                Layout.fillWidth: true
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
