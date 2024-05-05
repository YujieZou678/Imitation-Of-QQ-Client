/*
function: 仿QQ客户端。
author: zouyujie
date: 2024.3.18
*/
#include <QJsonArray>
#include <QDir>

#include "tcpclient.h"
#include "mythread.h"

TcpClient::TcpClient(QObject *parent)
    : QObject(parent)
{
    /* settings */
    settings = new QSettings("config/local.ini", QSettings::NativeFormat, this);

    /* 开启子线程 */
    thread = new QThread;     //不能设置父类
    myThread = new MyThread;  //不能设置父类
    myThread->moveToThread(thread);
    thread->start();

    /* 信号与槽机制 主线程和子线程交互 */
    /* 主——>子 */
    connect(this, &TcpClient::buildConnection, myThread, &MyThread::buildConnection);
    connect(this, &TcpClient::toSubThread_CheckAccountNumber, myThread, &MyThread::toServer_CheckAccountNumber);
    connect(this, &TcpClient::toSubThread_Register, myThread, &MyThread::toServer_Register);
    connect(this, &TcpClient::toSubThread_Login, myThread, &MyThread::toServer_Login);
    connect(this, &TcpClient::toSubThread_PrepareSendFile, myThread, &MyThread::toServer_PrepareSendFile);
    connect(this, &TcpClient::toSubThread_ChangePersonalData, myThread, &MyThread::toServer_ChangePersonalData);
    connect(this, &TcpClient::toSubThread_AddFriend, myThread, &MyThread::toServer_AddFriend);
    connect(this, &TcpClient::toSubThread_RequestGetProfileAndName, myThread, &MyThread::toServer_RequestGetProfileAndName);
    connect(this, &TcpClient::toSubThread_SaveChatHistory, myThread, &MyThread::toServer_SaveChatHistory);
    connect(this, &TcpClient::toSubThread_GetChatHistory, myThread, &MyThread::toServer_GetChatHistory);
    connect(this, &TcpClient::toSubThread_CreateGroup, myThread, &MyThread::toServer_CreateGroup);
    /* 子——>主 */
    connect(myThread, &MyThread::getReply_CheckAccountNumber, this, &TcpClient::getReplyFromSub_CheckAccountNumber);
    connect(myThread, &MyThread::getReply_Register, this, &TcpClient::getReplyFromSub_Register);
    connect(myThread, &MyThread::getReply_Login, this, &TcpClient::getReplyFromSub_Login);
    connect(myThread, &MyThread::finished_ReceiveFile, this, &TcpClient::getReplyFromSub_ReceiveFile);
    connect(myThread, &MyThread::finished_SeverReceiveFile, this, &TcpClient::getReplyFromSub_SeverReceiveFile);
    connect(myThread, &MyThread::getReply_GetPersonalData, this, &TcpClient::getReplyFromSub_GetPersonalData);
    connect(myThread, &MyThread::getReply_GetChatHistory, this, &TcpClient::getReplyFromSub_GetChatHistory);
    connect(myThread, &MyThread::getReply_RefreshFriendList, this, &TcpClient::getReplyFromSub_RefreshFriendList);
    connect(myThread, &MyThread::getReply_TransmitMsg, this, &TcpClient::getReplyFromSub_TransmitMsg);

    emit buildConnection();  //子线程与服务器建立连接
}

TcpClient::~TcpClient()
{
    qDebug() << "主线程" << QThread::currentThread() << ":"
             <<"主线程析构";

    myThread->deleteLater();  //子线程析构，直接释放则为主线程

    thread->quit();
    thread->wait();
    delete thread;
    thread = nullptr;
}

void TcpClient::toServer_CheckAccountNumber(const QString &checkAccountNumber, const QString &check)
{
    emit toSubThread_CheckAccountNumber(checkAccountNumber, check);
}

void TcpClient::toServer_Register(const QString &checkAccountNumber, const QString &password)
{
    emit toSubThread_Register(checkAccountNumber, password);
}

void TcpClient::toServer_Login(const QString &checkAccountNumber, const QString &password)
{
    emit toSubThread_Login(checkAccountNumber, password);
}

void TcpClient::toServer_PrepareSendFile(const QString&url, const QString&id)
{
    emit toSubThread_PrepareSendFile(url, id);
}

void TcpClient::toServer_ChangePersonalData(const QJsonObject &doc)
{
    emit toSubThread_ChangePersonalData(doc);
}

void TcpClient::toServer_AddFriend(const QJsonObject &obj)
{
    emit toSubThread_AddFriend(obj);
}

void TcpClient::toServer_RequestGetProfileAndName(const QString &accountNumber)
{
    emit toSubThread_RequestGetProfileAndName(accountNumber);
}

void TcpClient::toServer_SaveChatHistory(const QJsonObject &obj)
{
    emit toSubThread_SaveChatHistory(obj);
}

void TcpClient::toServer_GetChatHistory(const QString &accountNumber, const QString &friendAccountNumber)
{
    emit toSubThread_GetChatHistory(accountNumber, friendAccountNumber);
}

void TcpClient::toServer_CreateGroup(const QString &groupNumber, const QString &accountNumber)
{
    emit toSubThread_CreateGroup(groupNumber, accountNumber);  //群号 当前用户账号
}

void TcpClient::saveLocalCache_ChatHistory(const QJsonObject& obj)
{
/* json格式
 * AccountNumber,
 * FriendAccountNumber,
 * ChatHistory1:
 *          Msg,
 *          IsMyMsg
 * ChatHistory2:
 *          Msg,
 *          IsMyMsg
*/
    /* 保存本地缓存聊天记录 */
    QString accountNumber = obj["AccountNumber"].toString();
    QString friendAccountNumber = obj["FriendAccountNumber"].toString();
    QJsonObject historyArray = obj["ChatHistory1"].toObject();

    settings->setValue(accountNumber+"/ChatHistory/"+friendAccountNumber, historyArray);
}

QJsonObject TcpClient::getLocalCache_ChatHistory(const QString &accountNumber, const QString &friendAccountNumber)
{
    /* 获取本地缓存聊天记录 */
    settings->beginGroup(accountNumber);  //进入目录
    settings->beginGroup("ChatHistory");  //进入目录
    QJsonObject data = settings->value(friendAccountNumber).toJsonObject();
    settings->endGroup();                 //退出目录
    settings->endGroup();                 //退出目录

    return data;
}

bool TcpClient::fileIsExit(const QString &file)
{
    /* 判断某个文件是否存在 */
    QDir dir;
    bool exit = dir.exists(file);

    return exit;
}

void TcpClient::getReplyFromSub_CheckAccountNumber(const QString &isExit)
{
    emit getReply_CheckAccountNumber(isExit);
}

void TcpClient::getReplyFromSub_Register(const QString &isOk)
{
    emit getReply_Register(isOk);
}

void TcpClient::getReplyFromSub_Login(const QString &isRight)
{
    emit getReply_Login(isRight);
}

void TcpClient::getReplyFromSub_ReceiveFile(const QString&nickName, bool isReceive)
{
    emit finished_ReceiveFile(nickName, isReceive);
}

void TcpClient::getReplyFromSub_SeverReceiveFile()
{
    emit finished_SeverReceiveFile();
}

void TcpClient::getReplyFromSub_GetPersonalData(QJsonObject doc)
{
    emit getReply_GetPersonalData(doc);
}

void TcpClient::getReplyFromSub_GetChatHistory(const QJsonArray &chatHistory)
{
    emit getReply_GetChatHistory(chatHistory);
}

void TcpClient::getReplyFromSub_RefreshFriendList(const QJsonObject &doc)
{
    emit getReply_RefreshFriendList(doc);
}

void TcpClient::getReplyFromSub_TransmitMsg(const QJsonObject &doc)
{
    emit getReply_TransmitMsg(doc);
}

