#ifndef RECEIVER_H
#define RECEIVER_H

#include <QObject>
#include <QDateTime>

class Receiver : public QObject
{
    Q_OBJECT
public:
    explicit Receiver(QObject *parent = 0);
signals:
    void sendToQml(int count);

public slots:
    QString getCurrentDateTime1();
    void receiveFromQml(int count);

};

#endif // RECEIVER_H
