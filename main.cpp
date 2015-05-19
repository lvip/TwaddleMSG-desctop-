#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQml>
#include <QSqlDatabase>
#include <QtSql>
#include "receiver.h"
#include "server/client.h"
#include "audioinput.h"
#include "voipclient.h"



int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    //Плагины для qml
    qmlRegisterType<Client>("com.ics.demo", 1, 0, "Client");
    qmlRegisterType<InputTest>("com.ics.audio", 1, 0, "InputTest");
    qmlRegisterType<VoIPClient>("com.ics.voipclient", 1, 0, "VoIPClient");


    QQmlApplicationEngine engine;
    //QObject::connect(engine.QObject, SIGNAL(quit()), &app, SLOT(quit()));
    Receiver receiver;
    QQmlContext* ctx = engine.rootContext();
    ctx->setContextProperty("receiver", &receiver);
    engine.load(QUrl(QStringLiteral("qrc:/main2.qml")));
    return app.exec();
}
