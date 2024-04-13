/*
function: 仿QQ客户端。
author: zouyujie
date: 2024.3.18
*/
#include <QObject>
#include <QTcpSocket>
#include <QHostAddress>
#include <QImage>
#include <QBuffer>
#

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

#include "tcpclient.h"

TcpClient::TcpClient(QObject *parent)
    : QObject(parent)
{
    //client
    client = new QTcpSocket(this);
    client->connectToHost(QHostAddress::LocalHost, 2222);  //与服务端建立连接
    connect(client, &QTcpSocket::connected, this, &TcpClient::onConnected);
    connect(client, &QTcpSocket::readyRead, this, &TcpClient::onReadyRead);

    //map_Switch
    map_Switch = {
        {"CheckAccountNumber", Purpose::CheckAccountNumber},
        {"Register", Purpose::Register},
        {"Login", Purpose::Login},
        {"PrepareSendFile", Purpose::PrepareSendFile},
        {"SendFile", Purpose::SendFile},
        {"SingleChat", Purpose::SingleChat}
    };
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
    QString data_Purpose = doc["Purpose"].toString();
    enum Purpose purpose = map_Switch[data_Purpose];
    switch (purpose) {
    case Purpose::CheckAccountNumber: {
        QString reply = doc["Reply"].toString();
        emit getReply_CheckAccountNumber(reply);
        break;
    }
    case Purpose::Register: {
        break;
    }
    case Purpose::Login: {
        QString reply = doc["Reply"].toString();
        emit getReply_Login(reply);
        break;
    }
    case Purpose::PrepareSendFile: {
        QString reply = doc["Reply"].toString();
        emit getReply_PrepareSendFile(reply);
        break;
    }
    case Purpose::SendFile: {
        QString reply = doc["Reply"].toString();
        emit getReply_SendFile(reply);
        break;
    }
    default:
        break;
    }
}

void TcpClient::postRequest(const QByteArray &data)
{
    client->write(data);
}

QByteArray TcpClient::info_CheckAccountNumber(const QString &accountNumber)
{
    QJsonObject json;
    json.insert("Purpose", "CheckAccountNumber");  //目的
    json.insert("AccountNumber", accountNumber);  //账号
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    return data;
}

QByteArray TcpClient::info_Register(const QString &accountNumber, const QString &password)
{
    QJsonObject json;
    json.insert("Purpose", "Register");  //目的
    json.insert("AccountNumber", accountNumber);  //账号
    json.insert("Password", password);  //密码
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    return data;
}

QByteArray TcpClient::info_Login(const QString &accountNumber, const QString &password)
{
    QJsonObject json;
    json.insert("Purpose", "Login");  //目的
    json.insert("AccountNumber", accountNumber);  //账号
    json.insert("Password", password);  //密码
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    return data;
}

QByteArray TcpClient::info_PrepareSendFile(const QString &id)
{
    QImage image("/root/我的文件/静态壁纸/1Z42G40629-2-1200.jpg");
    QBuffer buffer;
    image.save(&buffer, "PNG", 0);

    QJsonObject json;
    json.insert("Purpose", "PrepareSendFile");  //目的
    json.insert("FileSize", buffer.size());
    json.insert("ID", id);
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    buffer.close();
    return data;
}

void TcpClient::sendFile(const QString &path)
{
    qDebug() << path;

    QImage image("/root/我的文件/静态壁纸/1Z42G40629-2-1200.jpg");
    QByteArray _data;
    QBuffer buffer(&_data);
    image.save(&buffer, "PNG", 0);
    QByteArray data = _data.toBase64();
    buffer.close();

    client->write(data);
}

