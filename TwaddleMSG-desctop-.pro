TEMPLATE = app

QT += sql qml quick widgets network multimedia

SOURCES += main.cpp \
    receiver.cpp \
    server/client.cpp \
    server/connection.cpp \
    server/peermanager.cpp \
    server/server.cpp \
    audioinput.cpp \
    voip.cpp \
    voipclient.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    receiver.h \
    server/client.h \
    server/connection.h \
    server/peermanager.h \
    server/server.h \
    audioinput.h \
    voip.h \
    voipclient.h
RC_FILE     = resources.rc

DISTFILES += \
    resources.rc
