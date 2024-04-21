/*
function: 封装socket及对它的操作，方便移入新线程。
author: zouyujie
date: 2024.4.16
*/
#ifndef MYTHREAD_H
#define MYTHREAD_H

#include <QObject>
#include <QTcpSocket>
#include <QBuffer>

class MyThread : public QObject
{
    Q_OBJECT

public:
    MyThread(QObject *parent = nullptr);
    ~MyThread();

    void buildConnection();  //构建连接

    void toServer_CheckAccountNumber(const QString&, const QString&);  //验证账号是否存在
    void toServer_Register(const QString&, const QString&);            //存入注册信息
    void toServer_Login(const QString&, const QString&);               //验证登陆信息
    void toServer_ReceiveFile(const QString&);                         //准备好接收文件
    void toServer_PrepareSendFile(const QString&, const QString&);     //准备发送文件
    void toServer_SendFile();                                          //开始发送文件
    void toServer_ChangePersonalData(QJsonObject);                     //更改个人资料
    void toServer_AddFriend(QJsonObject);                              //添加好友

signals:
    void getReply_CheckAccountNumber(const QString&);  //信号：收到验证账号的回复
    void getReply_Login(const QString&);               //信号：收到登陆的回复
    void finished_ReceiveFile();                       //信号：文件接收完毕
    void finished_SeverReceiveFile();                  //信号：服务端文件接收完毕
    void getReply_GetPersonalData(const QJsonObject&);  //信号：收到个人信息

public slots:
    void onConnected();     //连接到服务器
    void onDisconnected();  //与服务器断开连接
    void onReadyRead();     //收到服务器的信息

private:
    enum class Purpose {    //枚举(class内部使用)
        CheckAccountNumber,
        Register,
        Login,
        PrepareSendFile,
        SendFile,
        ReceiveFile,
        SingleChat
    };
    QMap<QString, enum Purpose> map_Switch;  //用于寻找信息是哪个目的

    /* 封装一个socket */
    QTcpSocket *socket;     //旧连接

    /* 发送文件数据 */
    QBuffer *buffer;        //与data绑定

    /* 接收文件数据 */
    bool ifNeedReceiveFile{false};  //是否需要接收文件
    QByteArray file;                //文件数据
    QString accountNumber;          //账号
    qint64 fileSize{0};             //文件大小
    qint64 receiveSize{0};          //已接收大小
    int count{0};                   //接收次数

    /* 大文件传输 */
//    MyThread *MyThread;     //子线程
//    QThread *thread;
};

#endif // MYTHREAD_H
