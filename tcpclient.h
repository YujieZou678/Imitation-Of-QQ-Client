/*
function: 仿QQ客户端。
author: zouyujie
date: 2024.3.18
*/
#ifndef TCPCLIENT_H
#define TCPCLIENT_H

#include <QObject>
#include <QMap>

class QTcpSocket;

class TcpClient : public QObject
{
    Q_OBJECT

public:
    TcpClient(QObject *parent = nullptr);
    ~TcpClient();

    Q_INVOKABLE void postRequest(const QByteArray&);  //发送请求
    Q_INVOKABLE QByteArray info_CheckAccountNumber(const QString&);  //验证账号是否存在
    Q_INVOKABLE QByteArray info_Register(const QString&, const QString&);  //存入注册信息
    Q_INVOKABLE QByteArray info_Login(const QString&, const QString&);  //验证登陆信息
    Q_INVOKABLE QByteArray info_PrepareSendFile(const QString &);  //准备发送文件
    Q_INVOKABLE void sendFile(const QString&);  //开始发送文件

signals:
    void getReply_CheckAccountNumber(const QString&);  //信号：收到验证账号的回复
    void getReply_Login(const QString&);  //信号：收到登陆的回复
    void getReply_PrepareSendFile(const QString&);  //信号：收到准备发送文件回复
    void getReply_SendFile(const QString&);  //信号：收到发送文件回复

public slots:
    void onConnected();     //连接到服务器
    void onDisconnected();  //与服务器断开连接
    void onReadyRead();     //收到服务器的信息

private:
    enum class Purpose {  //枚举(class内部使用)
        CheckAccountNumber,
        Register,
        Login,
        PrepareSendFile,
        SendFile,
        SingleChat
    };

    QMap<QString, enum Purpose> map_Switch;  //用于寻找信息是哪个目的
    QTcpSocket *client;  //嵌套字
};

#endif // TCPCLIENT_H
