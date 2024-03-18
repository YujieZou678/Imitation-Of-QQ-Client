/*
function: 仿QQ客户端。
author: zouyujie
date: 2024.3.18
*/
#include "tcpclient.h"

#include <QApplication>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    TcpClient w;
    return a.exec();
}
