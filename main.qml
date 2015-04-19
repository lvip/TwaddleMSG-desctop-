import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

Item {
    width: parent.width
    height: parent.height
    property real scaleFactor: Screen.pixelDensity / 5.0
    property int intScaleFactor: Math.max(1, scaleFactor)


    Image {
        id: image1
        fillMode: Image.Tile
        source: "qrc:/te.jpg"
        z: -1
        anchors.fill: parent
        rotation: 45
        Behavior on rotation {NumberAnimation{ easing.type: Easing.Linear;duration: 1000}}
        Behavior on opacity  {NumberAnimation{ easing.type: Easing.Linear;duration: 300}}
        //Behavior on OpacityAnimator{NumberAnimation{ easing.type: Easing.InQuad;duration: 1000}}
        MouseArea
            {
                id: addMouseArea
                clip: false
                transformOrigin: Item.Center
                anchors.fill: parent
                hoverEnabled: true
                onEntered: image1.opacity = 0.5
                onExited: image1.opacity  = 1

                onClicked:
                {
                    image1.rotation=(image1.rotation == 360) ? 45:image1.rotation+45
                }
            }

    }

}
