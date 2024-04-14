#ifndef MYSUBTHREAD_H
#define MYSUBTHREAD_H

#include <QObject>
#include <QTcpSocket>
#include <QBuffer>

class MySubThread  : public QObject
{
    Q_OBJECT

public:
    MySubThread(qintptr, QObject* parent = nullptr);
    ~MySubThread();
    void handleFile();  //处理文件

public slots:
    void onPrepareSendFile(const QString&);  //子线程准备传输文件
    void onSendFile();  //子线程传输文件

signals:
    void closeSubSignal();  //关闭子线程1号的信号,并传递参数

private:
    QTcpSocket *socket;  //子线程的socket

    QByteArray _data;  //文件数据
    QBuffer *_buffer;  //缓存工具对象
};

#endif // MYSUBTHREAD_H
