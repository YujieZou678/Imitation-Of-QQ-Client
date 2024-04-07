/*
function: 登陆成功后的用户界面。
author: zouyujie
date: 2024.4.6
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

ColumnLayout {

    property string profileImage: "qrc:/image/12.png"  //头像

    anchors.fill: parent
    spacing: 0

    Rectangle {  //上
        Layout.fillWidth: true
        Layout.preferredHeight: 200
        color: "lightblue"

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Item {  //菜单栏
                Layout.fillWidth: true
                Layout.preferredHeight: 35

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
            }  //end 菜单栏

            Item {  //头像位置
                Layout.fillWidth: true
                Layout.fillHeight: true

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {  //头像
                        Layout.fillHeight: true
                        Layout.preferredWidth: 130

                        MyProfileImage {
                            width: 100
                            height: 100
                            anchors.centerIn: parent
                            imgSrc: profileImage
                            ifNeedSpacing: false
                        }
                    }

                    Item {  //个性签名
                        Layout.fillHeight: true
                        Layout.preferredWidth: 300

                        Item {
                            anchors.verticalCenter: parent.verticalCenter
                            width: 240
                            height: 60

                            Text {
                                id: userName
                                width: parent.width
                                text: "云坠入雾里"
                                font {
                                    pointSize: 18
                                    family: mFONT_FAMILY
                                    bold: true
                                }
                                elide: Qt.ElideRight
                                color: "#eeffffff"
                            }
                            Text {
                                id: personalSignature
                                width: parent.width
                                text: "风吹哪页读哪页......"
                                anchors.top: userName.bottom
                                anchors.topMargin: 15
                                font {
                                    pointSize: 13
                                    family: mFONT_FAMILY
                                }
                                elide: Qt.ElideRight
                                color: "#eeffffff"
                            }
                        }
                    }
                }
            }  //end 头像位置
        }
    }

    Rectangle {  //中
        Layout.fillWidth: true
        Layout.preferredHeight: 530

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Item {  //菜单栏
                Layout.fillWidth: true
                Layout.preferredHeight: 60

                MyShapeLine {  //底下那根可以切换的线
                    id: lineSwitch
                    lineColor: "lightblue"
                    lineWidth: 2.5
                    lineStartX: 20
                    lineStartY: 60
                    lineEndX: 80
                    lineEndY: 60
                }

                MyShapeLine {  //底下那根线
                    lineOpacity: 0.1
                    lineStartX: 0
                    lineStartY: 60
                    lineEndX: window.width
                    lineEndY: 60
                }

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

                    Item {  //消息
                        Layout.fillHeight: true
                        Layout.preferredWidth: window.width/4
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                news.color = "gray"
                                contacts.color = "lightgray"
                                space.color = "lightgray"
                                channel.color = "lightgray"
                                lineSwitch.lineStartX = 20
                                lineSwitch.lineEndX = 80
                            }
                        }

                        Text {
                            id: news
                            text: "消息"
                            anchors.centerIn: parent
                            font {
                                pointSize: 14
                                family: mFONT_FAMILY
                            }
                            color: "gray"
                        }
                    }

                    Item {  //联系人
                        Layout.fillHeight: true
                        Layout.preferredWidth: window.width/4
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                contacts.color = "gray"
                                news.color = "lightgray"
                                space.color = "lightgray"
                                channel.color = "lightgray"
                                lineSwitch.lineStartX = 20 + window.width/4
                                lineSwitch.lineEndX = 80 + window.width/4
                            }
                        }

                        Text {
                            id: contacts
                            text: "联系人"
                            anchors.centerIn: parent
                            font {
                                pointSize: 14
                                family: mFONT_FAMILY
                            }
                            color: "lightgray"
                        }
                    }

                    Item {  //空间
                        Layout.fillHeight: true
                        Layout.preferredWidth: window.width/4
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                space.color = "gray"
                                contacts.color = "lightgray"
                                news.color = "lightgray"
                                channel.color = "lightgray"
                                lineSwitch.lineStartX = 20 + window.width/4*2
                                lineSwitch.lineEndX = 80 + window.width/4*2
                            }
                        }

                        Text {
                            id: space
                            text: "空间"
                            anchors.centerIn: parent
                            font {
                                pointSize: 14
                                family: mFONT_FAMILY
                            }
                            color: "lightgray"
                        }
                    }

                    Item {  //频道
                        Layout.fillHeight: true
                        Layout.preferredWidth: window.width/4
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                channel.color = "gray"
                                space.color = "lightgray"
                                contacts.color = "lightgray"
                                news.color = "lightgray"
                                lineSwitch.lineStartX = 20 + window.width/4*3
                                lineSwitch.lineEndX = 80 + window.width/4*3
                            }
                        }

                        Text {
                            id: channel
                            text: "频道"
                            anchors.centerIn: parent
                            font {
                                pointSize: 14
                                family: mFONT_FAMILY
                            }
                            color: "lightgray"
                        }
                    }
                }
            }

            Item {  //消息列表
                Layout.fillWidth: true
                Layout.preferredHeight: 470

                MyShapeLine {  //底下那根线
                    lineOpacity: 0.1
                    lineStartX: 0
                    lineStartY: 470
                    lineEndX: window.width
                    lineEndY: 470
                }

                Item {
                    anchors.fill: parent
                    MyListView {
                        id: newsListView
                    }
                }
            }
        }
    }

    Rectangle {  //下
        Layout.fillWidth: true
        Layout.preferredHeight: 70
        //color: "lightpink"
    }
}