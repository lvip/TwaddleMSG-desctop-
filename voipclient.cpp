#include "voipclient.h"
VoIPClient::VoIPClient(QObject *parent) : QThread(parent)
{
    localPORT=1234;
    remoteHOST= QHostAddress::Any;
    remotePORT=1234;
    qDebug()<< localPORT<<remoteHOST<<remotePORT;
    started=false;
    //this->run();
}

void VoIPClient::run(void)
{
    transmitter = new AudioTransmitter(localPORT, remoteHOST, remotePORT);
    reciever = new AudioReciever(localPORT, remoteHOST, remotePORT);
    reciever->Start();
    transmitter->Start();
    exec();

     transmitter->Stop();
     reciever->Stop();
     delete transmitter;
     delete reciever;

}
void VoIPClient::callfriend(void)
{
    if(!started)
    {
    start();
    started=true;
    transmitter = new AudioTransmitter(localPORT, remoteHOST, remotePORT);
    reciever = new AudioReciever(localPORT, remoteHOST, remotePORT);
    reciever->Start();
    transmitter->Start();
    qDebug()<< "callfriend";
    }
}
void VoIPClient::Call(void)
{
    start();
    run();
    qDebug()<< "call";
}

void VoIPClient::FinishCall(void)
{
    if(started)
    {
    transmitter->Stop();
    reciever->Stop();
    delete transmitter;
    delete reciever;
    started=false;
    }
    //exit(0);

}

void VoIPClient::SetLocalPort(quint16 PORT)
{
    localPORT = PORT;
}

void VoIPClient::SetRemoteHost(QHostAddress HOST)
{
    remoteHOST = HOST;
}

void VoIPClient::SetRemotePort(quint16 PORT)
{
    remotePORT = PORT;
}

