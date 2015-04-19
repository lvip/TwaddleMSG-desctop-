// myserver.h

#ifndef MYSERVER_H
#define MYSERVER_H

#include <QTcpServer>
#include "mythread.h"

class MyServer : public QTcpServer
{
    Q_OBJECT
public:
    explicit MyServer(QObject *parent = 0);
    void startServer();
signals:
    void sendToQml(int count);

public slots:
    QByteArray  getTH();

protected:
    void incomingConnection(qintptr socketDescriptor);
private:
   MyThread *thread;
};

#endif // MYSERVER_H
