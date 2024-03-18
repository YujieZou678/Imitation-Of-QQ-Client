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

private:
    QTcpSocket *client;
};

#endif // TCPCLIENT_H
