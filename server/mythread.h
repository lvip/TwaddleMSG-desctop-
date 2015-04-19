
#ifndef MYTHREAD_H
#define MYTHREAD_H

#include <QThread>
#include <QTcpSocket>
#include <QDebug>

class MyThread : public QThread
{
    Q_OBJECT
public:
    explicit MyThread(qintptr ID, QObject *parent = 0);

    void run();
public:
    QByteArray DataG;

signals:
    void error(QTcpSocket::SocketError socketerror);

public slots:
    void readyRead();
    void disconnected();
    QByteArray  getData();
private:
    QTcpSocket *socket;
    qintptr socketDescriptor;
};

#endif // MYTHREAD_H
