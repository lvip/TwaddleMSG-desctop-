
import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    property real scaleFactor: Screen.pixelDensity / 5.0
    property int intScaleFactor: Math.max(1, scaleFactor)
    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }


    Header
    {
        id: header1
        opacity: 0
        z:-5
        text: "TwaddleMSG"
        //rightMargin: icon.width

    }


    Item
    {
        id:itemL
        z:-1
        ListModel {
            id: pageModel
            ListElement {
                title: "mainpage"
                page: "/main.qml"
            }
            ListElement {
                title: "Настройки"
                page: "/ButtonPage.qml"
            }
            ListElement {
                title: "Список контактов"
                page: "ContactList.qml"
            }
            ListElement {
                title: "Просмотр ютуба"
                page: "/youtube/youtube.qml"
            }
        }
    }
    StackView {
        id: stackView2
        z:1
        anchors.top: header1.top
        //anchors.fill: parent
        // Implements back key navigation
        focus: true
        Keys.onReleased: if (event.key === Qt.Key_Back && stackView.depth > 1) {
                             stackView.pop();
                             event.accepted = true;
                         }

        initialItem: Login{}
    }
   StackView {
        id: stackView
        opacity: 0
        visible: false
        anchors.top: header1.bottom
        //anchors.fill: parent
        // Implements back key navigation
        focus: true
        Keys.onReleased: if (event.key === Qt.Key_Backspace && stackView.depth > 1) {
                             stackView.pop();
                             event.accepted = true;
                         }

        initialItem: Item {
            width: parent.width
            height: parent.height
            ListView {
                model: pageModel
                anchors.fill: parent
                delegate: AndroidDelegate {
                    text: title
                    onClicked: stackView.push(Qt.resolvedUrl(page))
                }
            }
        }
    }

    Component {
        id: touchStyle
        ButtonStyle {
            panel: Item {
                implicitHeight: 50*scaleFactor
                implicitWidth: 200*scaleFactor
                BorderImage {
                    anchors.fill: parent
                    antialiasing: true
                    border.bottom: 8
                    border.top: 8
                    border.left: 8
                    border.right: 8
                    anchors.margins: control.pressed ? -4 : 0
                    source: control.pressed ? "/images/images/button_pressed.png" : "/images/images/button_default.png"
                    Text {
                        text: control.text
                        anchors.centerIn: parent
                        color: "white"
                        font.pixelSize: 23
                        renderType: Text.NativeRendering
                    }
                }
            }
        }
    }

    Button {
        text: "Выход"
        style: touchStyle
        anchors.bottom : parent.bottom
        z:1
        onClicked: Qt.quit()
        Item {
            height: parent.height
            width: parent.height
            id: backButton

            Image {
                anchors.centerIn: parent
                scale:0.1
                width:  implicitWidth * scaleFactor
                height: implicitHeight * scaleFactor
                source: "/images/images/exit.png"
                MouseArea {
                    anchors.fill: parent
                    anchors.margins: - 10
                }
            }
        }
    }

}
