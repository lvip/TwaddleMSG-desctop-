#ifndef VOIP_H
#define VOIP_H


#include <QObject>
#include <QIODevice>
#include <QUdpSocket>
#include <QHostAddress>
#include <QAudioInput>
#include <QAudioOutput>

// Function returns constant audio format of all audio streams.


class AudioTransmitter : public QObject
{
    Q_OBJECT
    public:
        AudioTransmitter(quint16 localPort, QHostAddress remoteHost, quint16 remotePort);
        void Start(void);
        void Stop(void);
        QAudioFormat GetStreamAudioFormat(void);

    private:
        QUdpSocket socket;
        QAudioInput * audio_input;
        QIODevice * audio_device;
        quint16 localPORT;
        QHostAddress remoteHOST;
        quint16 remotePORT;
        const qint64 maxsize;

    private slots:
        void sendDatagrams(void);
};

// Class produces a device to recieve audio from the network and play it.
class AudioReciever : public QObject
{
    Q_OBJECT
    public:
        AudioReciever(quint16 localPort, QHostAddress remoteHost, quint16 remotePort);
        bool Start(void);
        void Stop(void);
        QAudioFormat GetStreamAudioFormat(void);

    private:
        QUdpSocket socket;
        QAudioOutput * audio_output;
        QIODevice * audio_device;
        quint16 localPORT;
        QHostAddress remoteHOST;
        quint16 remotePORT;

    private slots:
        void readPendingDatagrams(void);
};



#endif // VOIP_H
