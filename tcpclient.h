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
#include <QSettings>

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
    Q_INVOKABLE void toServer_RequestGetProfileAndName(const QString&);            //请求获取某好友头像和昵称
    Q_INVOKABLE void toServer_SaveChatHistory(const QJsonObject&);                 //上传聊天记录
    Q_INVOKABLE void toServer_GetChatHistory(const QString&, const QString&);      //获取与某好友的聊天记录

    Q_INVOKABLE void saveLocalCache_ChatHistory(const QJsonObject&);                   //保存本地缓存：聊天记录
    Q_INVOKABLE QJsonObject getLocalCache_ChatHistory(const QString&, const QString&); //获取本地缓存：聊天记录
    Q_INVOKABLE bool fileIsExit(const QString&);                                       //某个文件是否存在

signals:
    /* 与子线程通信 */
    void buildConnection();  //与服务端建立连接
    void toSubThread_CheckAccountNumber(const QString&, const QString&);
    void toSubThread_Register(const QString&, const QString&);
    void toSubThread_Login(const QString&, const QString&);
    void toSubThread_PrepareSendFile(const QString&, const QString&);
    void toSubThread_ChangePersonalData(QJsonObject);
    void toSubThread_AddFriend(const QJsonObject&);
    void toSubThread_RequestGetProfileAndName(const QString&);
    void toSubThread_SaveChatHistory(const QJsonObject&);
    void toSubThread_GetChatHistory(const QString&, const QString&);

    /* 与qml通信 */
    void getReply_CheckAccountNumber(const QString&);  //信号：收到验证账号的回复
    void getReply_Register(const QString&);            //信号：收到注册的回复
    void getReply_Login(const QString&);               //信号：收到登陆的回复
    void finished_ReceiveFile(const QString&, bool);         //信号：文件接收完毕
    void finished_SeverReceiveFile();                  //信号：服务端文件接收完毕
    void getReply_GetPersonalData(const QJsonObject&); //信号：收到个人信息
    void getReply_GetChatHistory(const QJsonArray&);   //信号：收到与某好友的聊天信息

public slots:
    /* 与子线程通信 */
    void getReplyFromSub_CheckAccountNumber(const QString&);
    void getReplyFromSub_Register(const QString &);
    void getReplyFromSub_Login(const QString&);
    void getReplyFromSub_ReceiveFile(const QString&, bool);
    void getReplyFromSub_SeverReceiveFile();
    void getReplyFromSub_GetPersonalData(QJsonObject);
    void getReplyFromSub_GetChatHistory(const QJsonArray&);

private:
    QSettings *settings;  //缓存对象

    QThread *thread;
    MyThread *myThread;  //子线程
};

#endif // TCPCLIENT_H
