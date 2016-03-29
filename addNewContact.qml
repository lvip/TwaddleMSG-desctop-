import QtQuick 2.3
import QtQuick.LocalStorage 2.0
Item {
    id:maincontactitem
    width: parent.width
    height: parent.height
    z:-5
    property var db: null
    Component.onCompleted: initContact();
        function initContact(){
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
                    var rs = tx.executeSql('SELECT * FROM Contact ORDER BY timesend limit 1');

                    var r = ""
                    for(var i = 0; i < rs.rows.length; i++) {
                        r = rs.rows.item(i).name+"\n"
                        nameValue.text=r;
                        console.log(r)

                    }
                }
            )
        }
         function saveip(name,ip)
             {
                //db = LocalStorage.openDatabaseSync("QQmlExampleDB", "1.0", "The Example QML SQL!", 1000000);
                 db.transaction(
                     function(tx) {
                 tx.executeSql('INSERT INTO Contact(name,ip) VALUES(?,?)', [name, ip]);})
             console.log(ip)
             }



    Image {
        id: image3
        x: 136
        y: 90
        width: 100
        height: 100
        smooth: true
        enabled: false
        rotation: -20
        fillMode: Image.Stretch
        source: "/te.jpg"
    }


    Text {
        id: iplabel
        x: 209
        y: 197
        width: 78
        height: 14
        text: qsTr("IP_adress:")
        color: "white"
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 12
    }
    InputBox
    {
        id: inputip
        Keys.onReturnPressed:
        {
        inputname.forceActiveFocus()}

        height: 30
        width: 250
        anchors.left: iplabel.right
        anchors.bottom: iplabel.bottom

    }
    InputBox
    {
        id: inputname
        Keys.onReturnPressed:
        {maincontactitem.saveip(inputname.text,inputip.text)
        inputip.forceActiveFocus()
        stackView.push(Qt.resolvedUrl("qrc:/ContactList.qml"))}

        height: 30
        width: 250
        anchors.left: namelabel.right
        anchors.bottom: namelabel.bottom

    }

    Text {
        id: namelabel
        x: 209
        y: 224
        width: 78
        height: 14
        color: "white"
        text: qsTr("Name")
        font.pixelSize: 12
    }
    Text {
        id: nameValue
        x: 333
        y: 224
        width: 78
        height: 14
        color: "white"
        text: qsTr("Подгузка имени")
        font.pixelSize: 12
    }

    Text {
        id: text3
        x: 209
        y: 249
        width: 78
        height: 14
        color: "white"
        text: qsTr("age")
        font.pixelSize: 12
    }

    Text {
        id: text4
        x: 209
        y: 275
        width: 78
        height: 14
        color: "white"
        text: qsTr("region")
        font.pixelSize: 12
    }




    Text {
        id: text7
        x: 333
        y: 249
        width: 78
        height: 14
        color: "white"
        text: qsTr("22")
        font.pixelSize: 12
    }

    Text {
        id: text8
        x: 333
        y: 275
        width: 78
        height: 14
        color: "white"
        text: qsTr("Moscow")
        font.pixelSize: 12
    }

    Image {
        id: image2
        x: 403
        y: 116
        z:5
        Behavior on rotation {NumberAnimation{ easing.type: Easing.Linear;duration: 1000}}
        Behavior on opacity  {NumberAnimation{ easing.type: Easing.Linear;duration: 300}}
        source: "/icons/icons/delete_icon.png"
        MouseArea
            {
                id: addMouseArea
                clip: false
                transformOrigin: Item.Center
                anchors.fill: parent
                hoverEnabled: true
                onEntered: opacity=0.5
                onExited: opacity=1

                onClicked:
                {
                    image2.rotation=(image2.rotation == 360) ? 45:image2.rotation+45
                }
            }
    }

}

