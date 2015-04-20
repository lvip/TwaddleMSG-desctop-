
import QtQuick 2.2
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.1

ScrollView {
    width: parent.width
    height: parent.height

    flickableItem.interactive: true


    ListView {
        anchors.fill: parent
        model: 15
        delegate: AndroidDelegate {
            text: "Контакт #" + modelData
            Menu { id: contextMenu
                MenuItem {
                    text: qsTr('Начать чат')
                    shortcut: "Ctrl+Enter"
                    onTriggered: stackView.push(Qt.resolvedUrl("/chat/chat.qml"))
                }
                MenuItem {
                    text: qsTr('Удалить из друзей')
                    shortcut: "Ctrl+DEL"
                    onTriggered: stackView.push(Qt.resolvedUrl("/chat/chat.qml"))
                }
                MenuItem {
                    text: qsTr('Сделать заметку о контакте')
                    shortcut: "Ctrl+L"
                    onTriggered: stackView.push(Qt.resolvedUrl("/chat/chat.qml"))
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
                                            stackView.push(Qt.resolvedUrl("/chat/chat.qml"))}
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
