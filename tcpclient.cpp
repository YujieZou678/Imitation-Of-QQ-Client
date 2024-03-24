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
    connect(client, &QTcpSocket::connected, this, &TcpClient::onConnected);
    connect(client, &QTcpSocket::disconnected, this, &TcpClient::onDisconnected);
    connect(client, &QTcpSocket::readyRead, this, &TcpClient::onReadyRead);
}

TcpClient::~TcpClient()
{
    client->disconnectFromHost();
}

void TcpClient::onConnected()
{
    qDebug() << "与服务器连接成功。";
}

void TcpClient::onDisconnected()
{
    qDebug() << "与服务器断开连接。";
}

void TcpClient::onReadyRead()
{
    if (client->bytesAvailable() <= 0) return;  //字节为空则退出
    QByteArray data = client->readAll();
    QJsonDocument doc = QJsonDocument::fromJson(data);
    QString reply = doc["Reply"].toString();
    emit getReply(reply);
}

void TcpClient::postRequest(const QByteArray &data)
{
    client->write(data);
}

QByteArray TcpClient::toJson_CheckAccountNumber(const QString &accountNumber)
{
    QJsonObject json;
    json.insert("purpose", "CheckAccountNumber");  //目的
    json.insert("accountNumber", accountNumber);  //账号
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    return data;
}

QByteArray TcpClient::toJson_Register(const QString &accountNumber, const QString &passWord)
{
    QJsonObject json;
    json.insert("purpose", "Register");  //目的
    json.insert("accountNumber", accountNumber);  //账号
    json.insert("passWord", passWord);  //密码
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    return data;
}

