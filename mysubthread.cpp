#include "mysubthread.h"
#include <QDebug>
#include <QBuffer>
#include <QImage>
#include <QThread>
#include <QDataStream>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

MySubThread::MySubThread(qintptr socketDescriptor, QObject* parent)
    : QObject(parent)
{
    //socket
    socket = new QTcpSocket(this);
    if (!socket->setSocketDescriptor(socketDescriptor)) {
        qDebug() << "socket->setSocketDescriptor(socketDescriptor) failed:";
        return;
    }

    //_buffer
    _buffer = new QBuffer(&_data, this);
}

MySubThread::~MySubThread()
{
    qDebug() << "主线程" << QThread::currentThread() << ":"
             <<"子线程析构";
    socket->disconnectFromHost();
}

void MySubThread::handleFile()
{
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "准备发送图像文件";
    _data.clear();  //清空文件数据
    _buffer->open(QIODevice::WriteOnly);  //写入
    QImage image("/root/我的文件/静态壁纸/184e83e4bce8bad62500e312cbeaae76_2_400x225.webp");
    if (!image.save(_buffer, "PNG", 0)) {
        qDebug() << "图像文件保存失败";
    }
    _buffer->close();  //关闭
}

void MySubThread::onPrepareSendFile(const QString &id)
{
    handleFile();

    QJsonObject json;
    json.insert("Purpose", "PrepareSendFile");  //目的
    json.insert("FileSize", _data.size());
    json.insert("ID", id);
    QJsonDocument doc(json);
    QByteArray data = doc.toJson();

    qintptr size = socket->write(data);
    qDebug() << size;
    qDebug() << "子线程" << QThread::currentThread() << ":"
             << "图像文件准备完毕 大小："+QString::number(_data.size());
    emit closeSubSignal();
}

void MySubThread::onSendFile()
{
    qintptr oneSend_Size = 4000000;  //一次最大传输:四百万
    if (_data.size() < oneSend_Size) {  //一次性传输
        qintptr fileSize = socket->write(_data);
        socket->flush();  //立刻传输
        qDebug() << "子线程" << QThread::currentThread() << ":"
                 << "图像文件发送完毕 大小："+QString::number(fileSize);
    }
    else {  //多次传输
        qintptr hadSend_Size = 0;  //已经传输的大小
        for (int i=0; i<1000; i++) {
            if (hadSend_Size >= _data.size()) {  //检测是否发送完毕
                qDebug() << "子线程" << QThread::currentThread() << ":"
                         << "图像文件发送完毕 大小："+QString::number(hadSend_Size);
                break;
            }

            QByteArray data;
            if (_data.size()-hadSend_Size < oneSend_Size) {  //最后一次字节不够
                data = _data.last(_data.size()-hadSend_Size);
            } else {
                data = _data.sliced(hadSend_Size, oneSend_Size);
            }
            qintptr oneWrite_Size = socket->write(data);
            socket->flush();  //立刻传输
            qDebug() << "子线程" << QThread::currentThread() << ":"
                     << "图像文件第"+QString::number(i+1)+"次发送 大小："+QString::number(oneWrite_Size);
            hadSend_Size += oneWrite_Size;
        }
    }

    emit closeSubSignal();
}
