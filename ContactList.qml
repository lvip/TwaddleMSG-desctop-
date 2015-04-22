
import QtQuick 2.3
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.1
  Item{
      id:com1
    Component.onDestruction: console.log("destroyed inline item: " + stackView.index)
    Rectangle
    {
       anchors.fill: parent
       color: "#11ffffff"
    }


ScrollView {
    width: parent.width
    height: parent.height

    flickableItem.interactive: true


    ListView {
        anchors.fill: parent
        model: 15
        z:40
        delegate: AndroidDelegateC {
            z:-100
            text: "Контакт #" + modelData
            Menu { id: contextMenu
                MenuItem {
                    text: qsTr('Начать чат')
                    shortcut: "Ctrl+Enter"
                    onTriggered: stackView.push(Qt.resolvedUrl("/chat/chat2.qml"))
                }
                MenuItem {
                    text: qsTr('Удалить из друзей')
                    shortcut: "Ctrl+DEL"
                    onTriggered: stackView.push(Qt.resolvedUrl("/chat/chat3.qml"))
                }
                MenuItem {
                    text: qsTr('Сделать заметку о контакте')
                    shortcut: "Ctrl+L"
                    onTriggered: stackView.push(Qt.resolvedUrl("/chat/chat4.qml"))
                }
                MenuItem {
                    text: qsTr('Информация о контакте')
                    shortcut: "Ctrl+I"
                    onTriggered: stackView.push(Qt.resolvedUrl("contact.qml"))
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
                                            stackView.push({item:Qt.resolvedUrl("/chat/chat3.qml"), destroyOnPop:true,replace:true})
                                        else
                                        stackView.push({item:Qt.resolvedUrl("/chat/chat3.qml"), destroyOnPop:true})
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
