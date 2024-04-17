/*
function: 仿QQ客户端。
author: zouyujie
date: 2024.3.18
*/
#ifndef TCPCLIENT_H
#define TCPCLIENT_H

#include <QObject>
#include <QThread>

class MySocket;

class TcpClient : public QObject
{
    Q_OBJECT

public:
    TcpClient(QObject *parent = nullptr);
    ~TcpClient();

    /* qml使用 */
    Q_INVOKABLE void toServer_CheckAccountNumber(const QString&);        //验证账号是否存在
    Q_INVOKABLE void toServer_Register(const QString&, const QString&);  //存入注册信息
    Q_INVOKABLE void toServer_Login(const QString&, const QString&);     //验证登陆信息

signals:
    /* 与子线程通信 */
    void buildConnection();  //与服务端建立连接
    void toSubThread_CheckAccountNumber(const QString&);
    void toSubThread_Register(const QString&, const QString&);
    void toSubThread_Login(const QString&, const QString&);

    /* 与qml通信 */
    void getReply_CheckAccountNumber(const QString&);  //信号：收到验证账号的回复
    void getReply_Login(const QString&);               //信号：收到登陆的回复

public slots:
    /* 与子线程通信 */
    void getReplyFromSub_CheckAccountNumber(const QString&);
    void getReplyFromSub_Login(const QString&);

private:
    QThread *thread;     //子线程
    MySocket *mySocket;  //封装的socket
};

#endif // TCPCLIENT_H
