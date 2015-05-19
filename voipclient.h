#ifndef VOIPCLIENT_H
#define VOIPCLIENT_H

#include <QThread>
#include "voip.h"

class VoIPClient : public QThread
{
    Q_OBJECT
    public:
        explicit VoIPClient(QObject *parent = 0);

        void SetLocalPort(quint16 PORT);
        void SetRemoteHost(QHostAddress HOST);
        void SetRemotePort(quint16 PORT);
        Q_INVOKABLE void callfriend(void);

    public slots:
        void Call(void);
        void FinishCall(void);

    protected:
        Q_INVOKABLE void run(void);

    private:
        AudioTransmitter * transmitter;
        AudioReciever * reciever;
        QHostAddress remoteHOST;
        quint16 localPORT;
        quint16 remotePORT;
        bool started;
};


#endif // VOIPCLIENT_H
