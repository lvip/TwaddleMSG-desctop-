import QtQuick 2.3

Item {
    id: button
    signal clicked
    property alias text: label.text
    property color baseColor: "#555"
    property color textColor: "#fff"
    height: Math.round(40 * scaleFactor)
    width: Math.round(160 * scaleFactor)
    activeFocusOnTab: true

    Rectangle {
        anchors.fill: button
        color: "#ffffff"
        anchors.bottomMargin: intScaleFactor
        radius: background.radius
    }

    Keys.onReturnPressed: clicked()

    Rectangle {
        id: background
        opacity: enabled ? 1 : 0.7
        Behavior on opacity {NumberAnimation{}}
        radius: height/2
        border.width: intScaleFactor * button.activeFocus ? 2 : 1
        border.color: Qt.darker(baseColor, 1.4)
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { color: mousearea.pressed ? baseColor : Qt.lighter(baseColor, 1.4) ; position: 0 }
            GradientStop { color: baseColor ; position: 1 }
        }

        Text {
            id: label
            anchors.centerIn: parent
            font.pixelSize: 22 * scaleFactor
            font.bold: true
            color: textColor
            style: Text.Raised
            styleColor: "#44000000"
        }

        MouseArea {
            id: mousearea
            onClicked: button.clicked()
            anchors.fill: parent
        }
    }
}
