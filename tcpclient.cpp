/*
function: 仿QQ客户端。
author: zouyujie
date: 2024.3.18
*/
#include "tcpclient.h"
#include "mysocket.h"

TcpClient::TcpClient(QObject *parent)
    : QObject(parent)
{
    /* 开启子线程 */
    thread = new QThread;     //不能设置父类
    mySocket = new MySocket;  //不能设置父类
    mySocket->moveToThread(thread);
    thread->start();

    /* 信号与槽机制 主线程和子线程交互 */
    /* 主——>子 */
    connect(this, &TcpClient::buildConnection, mySocket, &MySocket::buildConnection);
    connect(this, &TcpClient::toSubThread_CheckAccountNumber, mySocket, &MySocket::toServer_CheckAccountNumber);
    connect(this, &TcpClient::toSubThread_Register, mySocket, &MySocket::toServer_Register);
    connect(this, &TcpClient::toSubThread_Login, mySocket, &MySocket::toServer_Login);
    /* 子——>主 */
    connect(mySocket, &MySocket::getReply_CheckAccountNumber, this, &TcpClient::getReplyFromSub_CheckAccountNumber);
    connect(mySocket, &MySocket::getReply_Login, this, &TcpClient::getReplyFromSub_Login);

    emit buildConnection();  //子线程与服务器建立连接
}

TcpClient::~TcpClient()
{
    qDebug() << "主线程" << QThread::currentThread() << ":"
             <<"主线程析构";

    mySocket->deleteLater();  //子线程析构，直接释放则为主线程

    thread->quit();
    thread->wait();
    delete thread;
    thread = nullptr;
}

void TcpClient::toServer_CheckAccountNumber(const QString &checkAccountNumber)
{
    emit toSubThread_CheckAccountNumber(checkAccountNumber);
}

void TcpClient::toServer_Register(const QString &checkAccountNumber, const QString &password)
{
    emit toSubThread_Register(checkAccountNumber, password);
}

void TcpClient::toServer_Login(const QString &checkAccountNumber, const QString &password)
{
    emit toSubThread_Login(checkAccountNumber, password);
}

void TcpClient::getReplyFromSub_CheckAccountNumber(const QString &isExit)
{
    emit getReply_CheckAccountNumber(isExit);
}

void TcpClient::getReplyFromSub_Login(const QString &isRight)
{
    emit getReply_Login(isRight);
}

