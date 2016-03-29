
import QtQuick 2.3
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import com.ics.demo 1.0
import com.ics.audio 1.0
import com.ics.voipclient 1.0
import QtQuick.LocalStorage 2.0
//import QtQuick.Controls.Styles 1.1


Item {
    id: chatroot

    property int opacitypopup: 0
    property var db: null
    property int idcontact
    height: parent.height
    width: parent.width
    Component.onCompleted:
    {
        setprevMSG();
        addip();
    }
        function setprevMSG(){
            db = LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
            console.log("setprevMSG()")

            //обрашение к локальной базе данных
            db.transaction(
                function(tx) {
                    // Create the database if it doesn't already exist
                    tx.executeSql('CREATE TABLE IF NOT EXISTS History(id INTEGER NOT NULL PRIMARY KEY,messege TEXT, user_id INT,is_self INTEGER,timesend TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL)');

                    // Add (another) greeting row
                    //tx.executeSql('INSERT INTO History(salutation, salutee) VALUES ("bla","blub")');

                    // Show all added greetings
                    var rs = tx.executeSql('SELECT * FROM History WHERE user_id= ? ORDER BY timesend limit 100', [idcontact]);

                    var r = ""
                    for(var i = 0; i < rs.rows.length; i++) {
                        r = rs.rows.item(i).id + ", " + rs.rows.item(i).messege+"\n"
                        chatContent.append({"content": r,datt: new Date(rs.rows.item(i).timesend).toLocaleString()})
                        console.log(r)

                    }
                }
            )
            chatView.positionViewAtEnd()
        }
        function addip()
        {
            console.log("вызов addip")
            db.transaction(
                function(tx) {
                    var rs = tx.executeSql('SELECT * FROM Contact WHERE id=? ORDER BY timesend limit 1',[idcontact]);

                    var r = ""
                    for(var i = 0; i < rs.rows.length; i++) {
                        r = rs.rows.item(i).ip
                        client1.addAddress(r)
                        console.log("это ип в qml" +r)
                    }
                }
                )

        }

    InputTest{

        id:audio1

    }
    VoIPClient
    {
        id:audio2
    }

    Client
    {
        id:client1
        onNewMessage:  {
            chatBox.sendMessageToClient(from,message)}

    }
    Connections {
         target: client1

     }

    Rectangle{
     id:container1
     Component.onCompleted: state="reanchored"
     anchors.left: parent.left
     width: 100
     height: parent.height
     anchors.right: handle.left
     color:"#00ffffff"
     //Loader()
     ContactListTab{
         width: 200; height: 200
         anchors.fill: parent
         z:80
         id:clist

     }
     Behavior on opacity  {NumberAnimation{ easing.type: Easing.Linear;duration: 400}}
     states:[ State {
         name: "reanchored"
         AnchorChanges { target: container1;  anchors{left:chatroot.left ; right:handle.left} }
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


    ButtonI {
        z:30
        id: contanB
        anchors.left: chatBox.left
        anchors.top: chatroot.top
        onButtonClick:
        {
            //trect1.anchors.right= parent.right

           // container.state="reanchored"
            if(container1.state== "reanchored")
            {
                handle.opacity=0
                container1.opacity=0
                container1.state ="reanchored1"
            }
            else
            {
                handle.opacity=1
                container1.state ="reanchored"
                container1.opacity=1
            }

            console.log(container1.state)

        }

    }
    ButtonM {
        z:300
        id: callB
        anchors.left: contanB.right
        anchors.top: rectangle1.bottom
        label:"Позвонить"
        onButtonClick:audio2.callfriend()

    }
    ButtonM {
        z:300
        id: finishcallB
        anchors.left: callB.right
        anchors.top: rectangle1.bottom
        label:"Сбросить"
        onButtonClick:audio2.FinishCall()

    }
Rectangle {
    z:400
    id: handle
    //anchors.left:parent.right
    x:250
    width: 5
    height: parent.height
    color: handleMouseArea.pressed ? "blue" : "orange"
    Behavior on opacity  {NumberAnimation{ easing.type: Easing.Linear;duration: 400}}

    MouseArea {
        id: handleMouseArea
        drag.axis: "XAxis"
        drag.minimumX: 80
        drag.maximumX: 400
        drag.filterChildren: true
        hoverEnabled: true
        anchors.fill: parent
        drag.target: handle
        //drag.axis: Drag.XAxis
        onEntered:cursorShape=Qt.SizeHorCursor
    }
}
Rectangle{
    anchors.top: parent.top
    height: 30
    anchors.right: parent.right
    anchors.left: container1.right
    id:contactact
    //contactAction{}
}

Rectangle {

    id: chatBox
    opacity: 1
   // anchors.centerIn: top

    color: "#5d5b59"
    border.color: "black"
    border.width: 1
    radius: 5
    //height: parent.height
    width: parent.height
    anchors.top: contactact.top
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
        client1.sendMessage(data)
        chatContent.append({color: "orange",content: client1.nickName()+": " + data,datt: new Date().toLocaleString()})
        db.transaction(
            function(tx) {
        tx.executeSql('INSERT INTO History(messege, user_id,is_self) VALUES(?, ?, 0)', [data, idcontact]);})
        //client1.newMe
        //! [BluetoothSocket-5]
       // socket.stringData = data
        //! [BluetoothSocket-5]
        chatView.positionViewAtEnd()
        input.forceActiveFocus()

        input.focus = hasFocus;
    }

    function sendMessageToClient(nick,message)
    {
        chatContent.append({content: nick+": "+message,datt: new Date().toLocaleString()})
        chatView.positionViewAtEnd()
        db.transaction(
            function(tx) {
        tx.executeSql('INSERT INTO History(messege, user_id,i_self) VALUES(?, ?, 1)', [message, idcontact]);})
    }

    Item {
        id:chatitem
        anchors.fill: parent
        anchors.margins: 10
        anchors.bottom: parent.bottom
        ListModel {
            id: chatContent
            ListElement {
                content: "Connected to chat server"
                datt:"cutdate"
                color:"black"

            }

        }
        Rectangle
           {

               color: "darkgreen"
               width: 200
               height: 100
               opacity: opacitypopup
               z:500
               ListView {
                   id: tab_row
                   anchors.top: parent.top
                   model: 10
                   delegate: ButtonE     {
                       width: 10
                       height: 10
                       textFont.pixelSize: Math.floor(9*1)
                       normalColor: "#00000000"
                       highlightColor: "#0f000000"
                       cursorShape: Qt.PointingHandCursor
                       textColor: emodel.currentKeyIndex==index? "#333333" : Cutegram.currentTheme.masterColor
                       text: "Cutegram.normalizeText(emodel.keys[index])"
                       onClicked: emodel.currentKey = emodel.keys[index]
                   }
               }
               Behavior on opacity { NumberAnimation { duration: 500 } }

               anchors
               {
                   centerIn:parent
               }

               Text
               {
                   anchors
                   {
                       centerIn:parent
                   }
                   font.family: "Segoe UI Light"
                   font.pixelSize: 20
                   text : "POPUP"
                   color: "darkgrey"
               }

               MouseArea
               {
                   anchors.fill: parent

                   onClicked:
                   {
                       opacitypopup = 0
                   }
               }
           }
        InputBox
        {
            id: input
            ButtonE {
                id: emoji_btn
                anchors.right: input.right
                anchors.verticalCenter: input.verticalCenter
                height: 30*1
                width: height
                opacity:0.7
                highlightColor: "#220d80ec"
                normalColor: "#00000000"
                cursorShape: Qt.PointingHandCursor
                iconHeight: height*0.55
                icon: 0? "qrc:/images/images/emoji-light.png" : "qrc:/images/images/emoji.png"
                onClicked: {
                    chatroot.opacitypopup=1;
                }
            }
            Keys.onReturnPressed:
            {chatBox.sendMessage()
            input.forceActiveFocus()}

            height: sendButton.height+70
            width: parent.width -sendButton.width - 15
            anchors.left: parent.left
            anchors.bottom: chatitem.bottom

        }

        ButtonM {
            id: sendButton
            anchors.right: parent.right
            anchors.bottom: chatitem.bottom
            label: "Send"
            onButtonClick: chatBox.sendMessage()
        }
        ButtonM {
            id: voicebut
            anchors.right: sendButton.right
            anchors.bottom: sendButton.top
            label: audio1.getvollevel()
            onButtonClick: {voicebut.label=audio1.getvollevel();
            //audio2.run();
            audio2.Call();}

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
            Image {
              anchors.fill: parent;
              fillMode: Image.Tile
                 horizontalAlignment: Image.AlignLeft
                 verticalAlignment: Image.AlignTop
              source: "qrc:/images/images/telegram_background.png"
            }
            ScrollView {
                width: parent.width
                height: parent.height
               // anchors.margins: 5
                //flickableItem.interactive: true
                ListView {
                    id: chatView
                    delegate:delegateit

                    width: parent.width
                    height: parent.height
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
    //property string dattt: model.
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
           text: model.datt || "lightgray"
           z:20
           font.pixelSize: 10
           //text: receiver.getCurrentDateTime1()
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

         TextEdit {

             id: textInput2
             readOnly: true
             color:model.color
             anchors.margins: 5
             anchors.left: checkbox.right
             anchors.right: parent.right
             anchors.top: parent.top
             anchors.bottom: parent.bottom
             horizontalAlignment: Text.AlignLeft
             verticalAlignment: Text.AlignVCenter
             focus: true
             wrapMode: Text.WrapAtWordBoundaryOrAnywhere
             selectByMouse: true
             text: model.content
             textFormat: Text.RichText
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
