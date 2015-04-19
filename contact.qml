import QtQuick 2.0

Item {
    width: parent.width
    height: parent.height
    z:-5

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
        id: text1
        x: 209
        y: 197
        width: 78
        height: 14
        text: qsTr("Name:")
        color: "white"
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 12
    }

    Text {
        id: text2
        x: 209
        y: 224
        width: 78
        height: 14
        color: "white"
        text: qsTr("E-mail:")
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
        id: text5
        x: 333
        y: 197
        width: 78
        height: 14
        color: "white"
        text: qsTr("Alex")
        horizontalAlignment: Text.AlignLeft
        font.pixelSize: 12
    }

    Text {
        id: text6
        x: 333
        y: 224
        width: 78
        height: 14
        color: "white"
        text: qsTr("saff@gmail.com")
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

