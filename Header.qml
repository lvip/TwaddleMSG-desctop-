import QtQuick 2.3

Rectangle {
    property alias text: t.text
    property int rightMargin: 0

    anchors.top: parent.top
    width: parent.width
    height: 70 * scaleFactor
    color: "white"

    Item {
        height: parent.height
        width: parent.height
        id: backButton
        Image {
            anchors.centerIn: parent
            width:  implicitWidth * scaleFactor
            height: implicitHeight * scaleFactor
            source: "qrc:/icons/icons/back_icon.png"
            MouseArea {
                anchors.fill: parent
                anchors.margins: - 10
                onClicked: if (stackView) stackView.pop()
            }
        }
    }
    Text {
        id: t
        anchors.left: backButton.right
        anchors.leftMargin: 10 * scaleFactor
        anchors.right: parent.right
        anchors.rightMargin: rightMargin
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -3
        elide: Text.ElideMiddle
        font.bold: true
        font.pixelSize: 36 * scaleFactor
        color: "#555"
    }
    Rectangle {
        width: parent.width; height: 1
        anchors.bottom: parent.bottom
        color: "#bbb"
    }
}
