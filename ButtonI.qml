import QtQuick 2.3

Rectangle {
    // Identifier of the item
    id: button

    // Attaches to the Text element's text content
    property string label

    // Set appearance properties

    antialiasing: true
    border.width: 1
    border.color: "gray"
    color: "#222B4181"
    opacity: 1
    anchors.margins: 10
    height: buttonimage.height * 1.3
    width: buttonimage.width * 1.3
    radius: height/2

    Image {
        width: 30
        height: 30
        id: buttonimage
        opacity: 1
        smooth :true
        anchors.centerIn: parent
        source :"/icons/icons/list2.png"
    }

    // buttonClick() is callable and a signal handler,
    // onButtonClick is automatically created
    signal buttonClick()

    // Define the clickable area to be the whole rectangle
    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent    // Stretch the area to the parent's dimension
        onClicked: buttonClick()
    }


    // Scale the button when pressed
    scale: buttonMouseArea.pressed ? 1.1 : 1.0
    // Animate the scale property change
    Behavior on scale { NumberAnimation { duration: 55 } }
}
