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
    anchors.fill: parent

    ListView {
        id: listView
        anchors.fill: parent
        model: 10
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
                    listViewDelegateItem.forceActiveFocus()  //获取焦点
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
                        imgSrc: "qrc:/image/12.png"
                        ifNeedSpacing: false
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
                                        text: "21级-本科-班委群"
                                        font {
                                            pointSize: 14
                                            family: mFONT_FAMILY
                                        }
                                    }
                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        text: "昨天"
                                        font {
                                            pointSize: 13
                                            family: mFONT_FAMILY
                                        }
                                        color: "lightgray"
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
                                    text: "李老师:@软12-李明-学委 祭司等级待机时间副isjfdisdsha"
                                    font {
                                        pointSize: 11
                                        family: mFONT_FAMILY
                                    }
                                    color: "lightgray"
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }
            }
        }
    }  //end Component
}
