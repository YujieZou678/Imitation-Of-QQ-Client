/*
function: 仿QQ客户端。
author: zouyujie
date: 2024.3.18
*/
#ifndef TCPCLIENT_H
#define TCPCLIENT_H

class QTcpSocket;

#include <QObject>

class TcpClient : public QObject
{
    Q_OBJECT

public:
    TcpClient(QObject *parent = nullptr);
    ~TcpClient();

    QByteArray toJson_Register(const QString&, const QString&);  //注册信息转json格式发送

public slots:
    void onConnected();     //连接到服务器
    void onDisconnected();  //与服务器断开连接
    void onReadyRead();     //收到服务器的信息

private:
    QTcpSocket *client;  //嵌套字
    QString ip_port;     //本端的识别码，相当于身份证
};

#endif // TCPCLIENT_H
