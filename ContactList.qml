
import QtQuick 2.3
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.1
import com.ics.demo 1.0
import QtQuick.LocalStorage 2.0
//import Qt.WebSockets 1.0
  Item{
    id:com1
    property int idcont
    property var db: null
    Component.onDestruction: console.log("destroyed inline item: " + stackView.index)
    Component.onCompleted: initContactlist();
        function initContactlist(){
            db = LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
            console.log("initContact")

            //обрашение к локальной базе данных
            db.transaction(
                function(tx) {
                    // Create the database if it doesn't already exist
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Contact(id INTEGER NOT NULL PRIMARY KEY,
name TEXT,
ip TEXT,
timesend TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL)');


                    // Show all added greetings
                    var rs = tx.executeSql('SELECT * FROM Contact ORDER BY timesend');

                    var r=0
                    for(var i = 0; i < rs.rows.length; i++) {
                        r = rs.rows.item(i).id;

                        contactmodel.append({name: rs.rows.item(i).name,datt:"дата",ip:rs.rows.item(i).ip, idcontact:rs.rows.item(i).id});
                        com1.idcont=r;
                        console.log(rs.rows.item(i).name)
                        console.log(rs.rows.item(i).id)
                    }
                }
            )
        }

ListModel
{
    id:contactmodel
    ListElement {
        property int idcontact
        name: "здесь будет имя пользователя"
        datt:"здесь будет дата добавления"
        ip:"здесь будет ип"


    }
}
ScrollView {
    width: parent.width
    height: parent.height

    flickableItem.interactive: true


    ListView {
        anchors.fill: parent
        Component.onCompleted: {
                model = contactmodel
;
        }
        z:40
        delegate: AndroidDelegateC {
            z:-100
            property int id: model.idcontact
            text: "Контакт #" + model.name
            Menu { id: contextMenu
                MenuItem {
                    text: qsTr('Начать голосовой чат')
                    shortcut: "Ctrl+Enter"
                    onTriggered: stackView.push(Qt.resolvedUrl("/chat/voicechat.qml"))
                }
                MenuItem {
                    text: qsTr('Удалить из друзей')
                    shortcut: "Ctrl+DEL"
                    onTriggered: stackView.push(Qt.resolvedUrl("/chat/chat2.qml"))
                }
                MenuItem {
                    text: qsTr('Сделать заметку о контакте')
                    shortcut: "Ctrl+L"
                    onTriggered: stackView.push(Qt.resolvedUrl("/chat/chat4.qml"))
                }
                MenuItem {
                    text: qsTr('Добавить нового пользователя')
                    shortcut: "Ctrl+Enter"
                    onTriggered: stackView.push({item: Qt.resolvedUrl("qrc:/addNewContact.qml"),properties:{idcontact:idcontact}})
                }
                MenuItem {
                    text: qsTr('Информация о контакте')
                    shortcut: "Ctrl+I"
                    onTriggered: stackView.push({item: Qt.resolvedUrl("qrc:/contact.qml"),properties:{idcontact:idcontact}})
                }
            }
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                 onClicked:         if(mouse.button & Qt.RightButton) {
                                        contextMenu.popup()
                                        //stackView.push(Qt.resolvedUrl("contact.qml"))
                                    }
                                    else{
                                        if(stackView.depth>2)
                                        {
                                            //socket.sendTextMessage(qsTr("Hello Server!"))
                                            //client2.sendQueryToServer("Тест сооющение")
                                            stackView.push({item:Qt.resolvedUrl("/chat/chat3.qml"), destroyOnPop:true,replace:true,properties:{idcontact:idcontact}})
                                        }
                                        else
                                        {
                                            //socket.sendTextMessage(qsTr("Hello Server!"));
                                           // client2.sendQueryToServer("Тест сооющение")
                                            stackView.push({item:Qt.resolvedUrl("/chat/chat3.qml"), destroyOnPop:true,properties:{idcontact:idcontact}})
                                        }
                                    }
            }

        }
    }

    style: ScrollViewStyle {
        transientScrollBars: true
        handle: Item {
            implicitWidth: 14
            implicitHeight: 26
            Rectangle {
                color: "#424246"
                anchors.fill: parent
                anchors.topMargin: 6
                anchors.leftMargin: 4
                anchors.rightMargin: 4
                anchors.bottomMargin: 6
            }
        }
        scrollBarBackground: Item {
            implicitWidth: 14
            implicitHeight: 26
        }
    }
}
}
