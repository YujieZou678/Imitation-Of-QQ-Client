/*
function: 仿QQ客户端。
author: zouyujie
date: 2024.3.18
*/
#include <QObject>
#include <QTcpSocket>
#include <QHostAddress>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

#include "tcpclient.h"

TcpClient::TcpClient(QObject *parent)
    : QObject(parent)
{
    client = new QTcpSocket(this);
    client->connectToHost(QHostAddress::LocalHost, 2222);  //与服务端建立连接

    connect(client, &QTcpSocket::connected, this, [=](){
        qDebug() << "与服务器连接成功。";

        QString ip_port = client->localAddress().toString()  //ip
                          +":"
                          +QString::number(client->localPort());  //port
        qDebug() << ip_port;
    });
    connect(client, &QTcpSocket::disconnected, this, [=](){
        //
    });
    connect(client, &QTcpSocket::readyRead, this, [=](){
        if (client->bytesAvailable() <= 0) return;  //字节为空则退出
        //
    });
}

TcpClient::~TcpClient()
{
    client->disconnectFromHost();
}
