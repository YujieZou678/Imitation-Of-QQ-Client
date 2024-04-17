/*
function: 封装socket及对它的操作，方便移入新线程。
author: zouyujie
date: 2024.4.16
*/
#ifndef MYSOCKET_H
#define MYSOCKET_H

#include <QObject>
#include <QTcpSocket>
#include <QBuffer>

class MySocket : public QObject
{
    Q_OBJECT

public:
    MySocket(QObject *parent = nullptr);
    ~MySocket();

    void buildConnection();  //构建连接

    void toServer_CheckAccountNumber(const QString&);        //验证账号是否存在
    void toServer_Register(const QString&, const QString&);  //存入注册信息
    void toServer_Login(const QString&, const QString&);     //验证登陆信息
    void toServer_ReceiveFile();                             //准备好接收文件
    void toServer_PrepareSendFile();                         //发送文件的准备
    void toServer_SendFile();                                //开始发送文件

signals:
    void getReply_CheckAccountNumber(const QString&);  //信号：收到验证账号的回复
    void getReply_Login(const QString&);               //信号：收到登陆的回复
    void getReply_PrepareSendFile(const QString&);     //信号：收到准备发送文件回复
    void getReply_ReceiveFile();                       //信号：收到文件的信息，准备接收
    void getReply_SendFile(const QString&);            //信号：收到发送文件回复

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
    QByteArray data;        //文件数据
    QString ID;             //qq号
    qint64 fileSize{0};     //文件大小
    qint64 receiveSize{0};  //已接收大小
    int count{0};           //接收次数

    /* 大文件传输 */
//    MySocket *mySocket;     //新连接
//    QThread *thread;        //新线程
};

#endif // MYSOCKET_H
