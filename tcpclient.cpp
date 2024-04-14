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

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

#include "tcpclient.h"
#include "mysubthread.h"

TcpClient::TcpClient(QObject *parent)
    : QObject(parent)
{
    //client
    client = new QTcpSocket(this);
    client->connectToHost(QHostAddress::LocalHost, 2222);  //与服务端建立连接
    connect(client, &QTcpSocket::connected, this, &TcpClient::onConnected);
    connect(client, &QTcpSocket::readyRead, this, &TcpClient::onReadyRead);
    connect(client, &QTcpSocket::disconnected, this, &TcpClient::onDisconnected);

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
    qDebug() << "主线程" << QThread::currentThread() << ":"
             <<"主线程析构";
    client->disconnectFromHost();  //断开连接

    delete mySubThread;
    mySubThread = nullptr;

    thread->quit();
    thread->wait();
    delete thread;
    thread = nullptr;
}

void TcpClient::onConnected()
{
    qDebug() << "与服务器连接成功。";

    //mySubThread
    mySubThread = new MySubThread(client->socketDescriptor());
    thread = new QThread;
    mySubThread->moveToThread(thread);
    connect(this, &TcpClient::sendFile_SubThread, mySubThread, &MySubThread::onSendFile);
    connect(this, &TcpClient::prepareSendFile_SubThread, mySubThread, &MySubThread::onPrepareSendFile);
    connect(mySubThread, &MySubThread::closeSubSignal, this, &TcpClient::onCloseSubThread);
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

void TcpClient::onCloseSubThread()
{
    thread->quit();
    qDebug() << "主线程" << QThread::currentThread() << ":"
             << "子线程已关闭";
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

void TcpClient::prepareSendFile(const QString &id)
{
    thread->start();
    qDebug() << "主线程" << QThread::currentThread() << ":"
             << "子线程已启用";
    emit prepareSendFile_SubThread(id);
}

void TcpClient::sendFile()
{
    thread->start();
    qDebug() << "主线程" << QThread::currentThread() << ":"
             << "子线程已启用";
    emit sendFile_SubThread();
}

