#include "voip.h"
AudioReciever::AudioReciever(quint16 localPort, QHostAddress remoteHost, quint16 remotePort)
{
    localPORT = localPort;
    remoteHOST = remoteHost;
    remotePORT = remotePort;
}
QAudioFormat AudioReciever::GetStreamAudioFormat(void)
{
   QAudioFormat format;
   format.setSampleRate(44100);
   //format.setChannels(1);
   format.setSampleSize(24);
   format.setCodec("audio/pcm");
   format.setByteOrder(QAudioFormat::LittleEndian);
   format.setSampleType(QAudioFormat::UnSignedInt);

   QAudioDeviceInfo info = QAudioDeviceInfo::defaultInputDevice();
   if (!info.isFormatSupported(format))
       format = info.nearestFormat(format);

   return format;
}

bool AudioReciever::Start(void)
{
    qDebug()<< "Ресивер старт";
    audio_output = new QAudioOutput(GetStreamAudioFormat());
    audio_output->setVolume(1.0);
    audio_device = audio_output->start();

    connect(&socket, SIGNAL(readyRead()), this, SLOT(readPendingDatagrams()));
    return  socket.bind(QHostAddress::Any, 45001,QUdpSocket::ShareAddress
                        | QUdpSocket::ReuseAddressHint);


}

void AudioReciever::Stop(void)
{
    audio_output->stop();
    delete audio_output;
    socket.close();
    disconnect(&socket, SIGNAL(readyRead()), this, SLOT(readPendingDatagrams()));
}

void AudioReciever::readPendingDatagrams(void)
{

    //qDebug()<<"readPendingDatagrams2: ";
    while (socket.hasPendingDatagrams())
    {
        QByteArray datagram;
        //datagram.resize(udpSocket->pendingDatagramSize());
        QHostAddress sender;
        quint16 senderPort;
        qint64 size = socket.pendingDatagramSize();
        char * data = new char[size];
        socket.readDatagram(data, size,&sender, &senderPort);
        audio_device->write(data, size);
        //qDebug()<<"readPendingDatagrams: "<<data;
        //qDebug()<<"Sender: "<<sender<<" senderPort: "<<senderPort<<"localPort()"<<socket.localPort()<<"peerPort()"<<socket.peerPort();
    }
}
AudioTransmitter::AudioTransmitter(quint16 localPort, QHostAddress remoteHost, quint16 remotePort)
    : maxsize(8192)
{
    localPORT = localPort;
    remoteHOST = remoteHost;
    remotePORT = remotePort;
}
QAudioFormat AudioTransmitter::GetStreamAudioFormat(void)
{
   QAudioFormat format;
   QAudioDeviceInfo info1 = QAudioDeviceInfo::defaultInputDevice();
   format.setSampleRate(44100);
   //format.setChannels(1);
   format.setSampleSize(24);
   format.setCodec("audio/pcm");
   format.setByteOrder(QAudioFormat::LittleEndian);
   format.setSampleType(QAudioFormat::UnSignedInt);

   QAudioDeviceInfo info = QAudioDeviceInfo::defaultInputDevice();
   if (!info.isFormatSupported(format))
       format = info.nearestFormat(format);
   QStringList list=info1.supportedCodecs();
   foreach (const QString &str, list) {
       qDebug()<<"codec: "<<str;
   }

   return format;
}

void AudioTransmitter::Start(void)
{
    audio_input = new QAudioInput(GetStreamAudioFormat());
    audio_input->setVolume(1.0);
    audio_device = audio_input->start();
    connect(audio_device, SIGNAL(readyRead()), this, SLOT(sendDatagrams()));
    qDebug()<< "Трасмитер старт";
}

void AudioTransmitter::Stop(void)
{
    audio_input->stop();
    delete audio_input;
    socket.close();
    disconnect(audio_device, SIGNAL(readyRead()), this, SLOT(sendDatagrams()));
}


void AudioTransmitter::sendDatagrams(void)
{
    QByteArray tmp = audio_device->read(maxsize);
    socket.writeDatagram(tmp.data(), tmp.size(), QHostAddress("188.255.85.134"), remotePORT);
    //qDebug()<< "senddatagramm remotePORT"<<remotePORT;
}


