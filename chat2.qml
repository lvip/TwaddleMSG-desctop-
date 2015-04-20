
import QtQuick 2.3
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
//import QtQuick.Controls.Styles 1.1


Item {
    id: chatroot

    Component.onCompleted: state = "chatActive"

    property string remoteDeviceName: ""
    property bool serviceFound: false




    //! [BtDiscoveryModel-2]
    //! [BtDiscoveryModel-3]
    //! [BtDiscoveryModel-3]

    //! [BluetoothSocket-1]
    //! [BluetoothSocket-1]
    //! [BluetoothSocket-3]
    //! [BluetoothSocket-4]
    //! [BluetoothSocket-2]
     //! [BluetoothSocket-2]



    Item {
        id: container1
        z:60
        opacity:0
        width: 200; height: 200
        anchors.right: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        ContactList{
            width: 200; height: 200
            anchors.fill: parent
            z:80
            id:clist

        }
        Behavior on opacity  {NumberAnimation{ easing.type: Easing.Linear;duration: 400}}
        states:[ State {
            name: "reanchored"
            AnchorChanges { target: container1;  anchors{left:chatroot.left ; right:undefined} }
        },
        State {
                    name: "reanchored1"
                    AnchorChanges { target: container1; anchors{left:undefined ; right:chatroot.left}}
                }
    ]
        transitions: Transition {
            // smoothly reanchor myRect and move into new position
            AnchorAnimation { duration: 500 }
        }


    }
    ButtonM {
        z:30
        id: contanB
        anchors.right: chatroot.right
        anchors.top: chatroot.top
        label: "Развернуть список"
        onButtonClick:
        {
            //trect1.anchors.right= parent.right

           // container.state="reanchored"
            if(container1.state== "reanchored")
            {
                container1.opacity=0
                container1.state ="reanchored1"
            }
            else
            {
                container1.state ="reanchored"
                container1.opacity=1
            }

            console.log(container1.state)

        }

    }





    Rectangle {

        id: chatBox
        opacity: 0
       // anchors.centerIn: top

        color: "#5d5b59"
        border.color: "black"
        border.width: 1
        radius: 5
        height: parent.height
        width: parent.height
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: container1.right

        function sendMessage()
        {
            // toogle focus to force end of input method composer
            var hasFocus = input.focus;
            input.focus = false;

            var data = input.text
            input.clear()

            chatContent.append({content: "Me: " + data})
            //! [BluetoothSocket-5]
           // socket.stringData = data
            //! [BluetoothSocket-5]
            chatView.positionViewAtEnd()
            input.forceActiveFocus()

            input.focus = hasFocus;
        }

        Item {
            anchors.fill: parent
            anchors.margins: 10
            anchors.bottom: parent.bottom
            ListModel {
                id: chatContent
                ListElement {
                    content: "Connected to chat server"
                }
            }

            InputBox
            {
                id: input
                Keys.onReturnPressed:
                {chatBox.sendMessage()
                input.forceActiveFocus()}

                height: sendButton.height
                width: parent.width -clearA.width -sendButton.width - 15
                anchors.left: parent.left
                anchors.top: rectangle1.bottom

            }

            ButtonM {
                id: sendButton
                anchors.left: clearA.right
                anchors.top: rectangle1.bottom
                label: "Send"
                onButtonClick: chatBox.sendMessage()
            }

            ButtonM {
                id: clearA
                anchors.left: input.right
                anchors.top: rectangle1.bottom
                label: "Удалить всё"
                onButtonClick: chatContent.clear()
            }


            Rectangle {
                id: rectangle1
                //height: parent.height - input.height - 50
                height: parent.height - input.height - 50
                width: parent.width;
                color: "#aad6d5"
                anchors.top: parent.top
                border.color: "black"
                border.width: 1
                radius: 5
                ScrollView {
                    width: parent.width
                    height: parent.height
                   // anchors.margins: 5
                    flickableItem.interactive: true
                    ListView {
                        id: chatView
                        delegate:delegateit
                        anchors.margins: 30

                        width: parent.width-5
                        height: parent.height-5
                        //anchors.centerIn: parent
                        model: chatContent
                        spacing: 10
                        clip: true
                        add: Transition { NumberAnimation { properties: "y"; from: parent.height; duration: 250 } }
                        removeDisplaced: Transition { NumberAnimation { properties: "y"; duration: 300 } }
                        remove: Transition { NumberAnimation { property: "opacity"; to: 0; duration: 300 } }

                    }
                }
            }
        }
    }

    //элемент чата
    Component {
        id: delegateit

        //делегат для листа
        BorderImage {
            id: item
           //z:6
           width: parent.width
           anchors.margins: 10
           height: textInput2.contentHeight+30
           border.left: 5; border.top: 5
           border.right: 5; border.bottom: 5
           //color:"gray"
           //color: index % 2 === 0 ? "#EEE" : "#DDD"
           source: mouse.pressed ? "/chat/chat/delegate_pressed.png" : "/chat/chat/delegate.png"
           transform: Rotation { id:rt; origin.x: width; origin.y: height; axis { x: 0.3; y: 1; z: 0 } angle: 0}//
           SequentialAnimation {
                 id: showAnim
                 running: false
                 RotationAnimation { target: rt; from: 180; to: 0; duration: 800; easing.type: Easing.OutBack; property: "angle" }
             }
           MouseArea {
               id: mouse
               anchors.fill: parent
               hoverEnabled: true
               onClicked: {
                   if (index !== -1 && _synced) {
                       enginioModel.setProperty(index, "completed", !completed)
                   }
               }
           }
           Image {
               id: checkbox
               anchors.left: parent.left
               anchors.leftMargin: 16
               width: 32
               fillMode: Image.PreserveAspectFit
               anchors.verticalCenter: parent.verticalCenter
               source: "/chat/chat/checkbox_checked.png"
           }
           Menu { id: contextMenu
               MenuItem {
                   text: qsTr('Копировать сообщение')
                  // shortcut: "Ctrl+C"
                   //onTriggered:   item.
               }
               MenuItem {
                   text: qsTr('Удалить сообщение')
                   shortcut: "Ctrl+DEL"
                   onTriggered: chatContent.remove(index)
               }
               MenuItem {
                   text: qsTr('Информация о сообщении')
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
                                   else{}
           }
           Text{
               id:dataT
               z:20
               font.pixelSize: 10
               text: receiver.getCurrentDateTime1()
               Connections {
                   target: receiver
                   onSendToQml: {
                       console.log("Received in QML from C++: " + count)
                   }
               }
               //Connections {
             //      target: applicationData1
               //    onDataChanged: console.log("The application data changed!")
               //}
           }
        /* TextInput {
               z:7
               id:textMSG
               readOnly: true
               focus:true
               anchors.top: dataT.bottom
               anchors.fill: parent
               horizontalAlignment: Text.AlignHCenter
               verticalAlignment: Text.AlignVCenter
               //elide: Text.ElideRight
               anchors.verticalCenter: parent.verticalCenter
               //anchors.left: checkbox.right
               anchors.right: parent.right
               anchors.leftMargin: 12
               anchors.rightMargin: 40
               wrapMode: Text.Wrap
               //renderType: Text.NativeRendering
               text: modelData
               selectByMouse: true
           }*/
             TextInput {

                 id: textInput2
                 readOnly: true
                 anchors.margins: 5
                 anchors.left: checkbox.right
                 anchors.right: parent.right
                 anchors.top: parent.top
                 anchors.bottom: parent.bottom
                 horizontalAlignment: Text.AlignLeft
                 verticalAlignment: Text.AlignVCenter
                 focus: true
                 wrapMode: Text.WrapAnywhere
                 selectByMouse: true
                 text: modelData
                 font.pixelSize: 15
             }
         }
        }
    states: [
        State {
            name: "begin"
            PropertyChanges { target: searchBox; opacity: 1 }
            PropertyChanges { target: chatBox; opacity: 0 }
        },
        State {
            name: "chatActive"
            PropertyChanges { target: searchBox; opacity: 0 }
            PropertyChanges { target: chatBox; opacity: 1 }

            PropertyChanges {
                target: rectangle1
                transformOrigin: Item.Center
            }
        }
    ]
}
