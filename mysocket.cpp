/*
function: 封装socket及对它的操作，方便移入新线程。
author: zouyujie
date: 2024.4.16
*/
#include <QThread>
#include <QImage>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

#include "mysocket.h"

MySocket::MySocket(QObject *parent) :
    QObject(parent)
{
    //map_Switch
    map_Switch = {
        {"CheckAccountNumber", Purpose::CheckAccountNumber},
        {"Register", Purpose::Register},
        {"Login", Purpose::Login},
        {"PrepareSendFile", Purpose::PrepareSendFile},
        {"SendFile", Purpose::SendFile},
        {"ReceiveFile", Purpose::ReceiveFile},
        {"SingleChat", Purpose::SingleChat}
    };

    //buffer
    buffer = new QBuffer(&data, this);
}

MySocket::~MySocket()
{
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "子线程析构。";

    socket->disconnectFromHost();
}

void MySocket::buildConnection()
{
    //socket
    socket = new QTcpSocket(this);
    socket->connectToHost(QHostAddress::LocalHost, 2222);  //与服务端建立连接
    connect(socket, &QTcpSocket::connected, this, &MySocket::onConnected);
    connect(socket, &QTcpSocket::readyRead, this, &MySocket::onReadyRead);
    connect(socket, &QTcpSocket::disconnected, this, &MySocket::onDisconnected);
}

void MySocket::onConnected()
{
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "与服务器连接成功。";
}

void MySocket::onDisconnected()
{
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "与服务器断开连接。";
}

void MySocket::onReadyRead()
{
    if (socket->bytesAvailable() <= 0) return;  //字节为空则退出
    QByteArray data = socket->readAll();
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
    case Purpose::ReceiveFile: {
        break;
    }
    default:
        break;
    }
}

void MySocket::toServer_CheckAccountNumber(const QString &accountNumber)
{
    QJsonObject json;
    json.insert("Purpose", "CheckAccountNumber");  //目的
    json.insert("AccountNumber", accountNumber);   //账号
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    socket->write(data);
}

void MySocket::toServer_Register(const QString &accountNumber, const QString &password)
{
    QJsonObject json;
    json.insert("Purpose", "Register");  //目的
    json.insert("AccountNumber", accountNumber);  //账号
    json.insert("Password", password);  //密码
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    socket->write(data);
}

void MySocket::toServer_Login(const QString &accountNumber, const QString &password)
{
    QJsonObject json;
    json.insert("Purpose", "Login");  //目的
    json.insert("AccountNumber", accountNumber);  //账号
    json.insert("Password", password);  //密码
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    socket->write(data);
}

void MySocket::toServer_ReceiveFile()
{
    QJsonObject json;
    json.insert("Purpose", "ReceiveFile");  //目的
    json.insert("Reply", "true");
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    socket->write(data);
}

void MySocket::toServer_PrepareSendFile()
{
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "准备发送图像文件";

    /* 处理文件 */
    data.clear();       //清空文件数据
    ID = "2894841947";  //赋值

    buffer->open(QIODevice::WriteOnly);  //打开
    QImage image("/root/我的文件/静态壁纸/23.png");
    if (!image.save(buffer, "PNG", 0)) {
        qDebug() << "图像文件保存失败";
    }
    buffer->close();  //关闭

    /* 发送信息 */
    if (data.size() >= 1024*1024*10) {  //压缩后大于10M视为大文件
        qDebug() << "子线程" << QThread::currentThread() << ":"
                 << "当前不支持传输大文件";
        return;
    }

    QJsonObject json;
    json.insert("Purpose", "PrepareSendFile");  //目的
    json.insert("FileSize", data.size());
    json.insert("ID", ID);
    QJsonDocument doc(json);
    QByteArray send_Data = doc.toJson();

    socket->write(send_Data);
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "图像文件准备完毕 大小："+QString::number(data.size());
}

void MySocket::toServer_SendFile()
{
    qintptr oneSend_Size = 4000000;     //一次最大传输:四百万 字节
    if (data.size() < oneSend_Size) {   //一次性传输
        qintptr send_FileSize = socket->write(data);
        socket->flush();  //立刻传输
        qDebug() << "子线程" << QThread::currentThread() << ":"
                 << "图像文件发送完毕 大小："+QString::number(send_FileSize);
    }
    else {  //需要多次传输
        qintptr hadSend_Size = 0;  //已经传输的大小
        for (int i=0; i<1000; i++) {
            if (hadSend_Size >= data.size()) {  //检测是否发送完毕
                qDebug() << "子线程" << QThread::currentThread() << ":"
                         << "图像文件发送完毕 大小："+QString::number(hadSend_Size);
                break;
            }

            QByteArray send_Data;
            if (data.size()-hadSend_Size < oneSend_Size) {  //最后一次字节不够
                send_Data = data.last(data.size()-hadSend_Size);
            } else {
                send_Data = data.sliced(hadSend_Size, oneSend_Size);
            }
            qintptr oneWrite_Size = socket->write(send_Data);
            socket->flush();  //立刻传输
            qDebug() << "子线程" << QThread::currentThread() << ":"
                     << "图像文件第"+QString::number(i+1)+"次发送 大小："+QString::number(oneWrite_Size);
            hadSend_Size += oneWrite_Size;
        }
    }
}




