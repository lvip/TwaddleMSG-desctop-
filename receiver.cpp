#include "receiver.h"
#include <QDebug>


Receiver::Receiver(QObject *parent) :
    QObject(parent)
{
}

void Receiver::receiveFromQml(int count) {
    qDebug() << "Received in C++ from QML:" << count;
}
QString Receiver::getCurrentDateTime1()
    {
        QDateTime curD = QDateTime::currentDateTime();

        return curD.toString("ddd.MMMM.d.yy   hh:mm:ss");
    }
