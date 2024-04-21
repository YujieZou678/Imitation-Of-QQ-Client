/*
function: 仿QQ客户端。
author: zouyujie
date: 2024.3.18
*/
#ifndef TCPCLIENT_H
#define TCPCLIENT_H

#include <QObject>
#include <QThread>
#include <QJsonObject>

class MyThread;

class TcpClient : public QObject
{
    Q_OBJECT

public:
    TcpClient(QObject *parent = nullptr);
    ~TcpClient();

    /* qml使用 */
    Q_INVOKABLE void toServer_CheckAccountNumber(const QString&, const QString&);  //验证账号是否存在
    Q_INVOKABLE void toServer_Register(const QString&, const QString&);            //存入注册信息
    Q_INVOKABLE void toServer_Login(const QString&, const QString&);               //验证登陆信息
    Q_INVOKABLE void toServer_PrepareSendFile(const QString&, const QString&);     //更改头像
    Q_INVOKABLE void toServer_ChangePersonalData(const QJsonObject&);              //更改个人资料
    Q_INVOKABLE void toServer_AddFriend(const QJsonObject&);                       //添加好友

signals:
    /* 与子线程通信 */
    void buildConnection();  //与服务端建立连接
    void toSubThread_CheckAccountNumber(const QString&, const QString&);
    void toSubThread_Register(const QString&, const QString&);
    void toSubThread_Login(const QString&, const QString&);
    void toSubThread_PrepareSendFile(const QString&, const QString&);
    void toSubThread_ChangePersonalData(QJsonObject);
    void toSubThread_AddFriend(const QJsonObject&);

    /* 与qml通信 */
    void getReply_CheckAccountNumber(const QString&);  //信号：收到验证账号的回复
    void getReply_Login(const QString&);               //信号：收到登陆的回复
    void finished_ReceiveFile();                       //信号：文件接收完毕
    void finished_SeverReceiveFile();                  //信号：服务端文件接收完毕
    void getReply_GetPersonalData(const QJsonObject&); //信号：收到个人信息

public slots:
    /* 与子线程通信 */
    void getReplyFromSub_CheckAccountNumber(const QString&);
    void getReplyFromSub_Login(const QString&);
    void getReplyFromSub_ReceiveFile();
    void getReplyFromSub_SeverReceiveFile();
    void getReplyFromSub_GetPersonalData(QJsonObject);

private:
    QThread *thread;
    MyThread *myThread;  //子线程
};

#endif // TCPCLIENT_H
