import QtQuick 2.0

import QtQuick 2.0

Rectangle {
    id: button
    smooth: true
    width: row.width + 20*Devices.density
    height: 30*Devices.density
    color: press? highlightColor : (enter?hoverColor:normalColor)

    property alias text: txt.text
    property alias icon: icn.source
    property alias fontSize: txt.font.pixelSize
    property alias textFont: txt.font

    property alias hoverEnabled: marea.hoverEnabled

    property alias iconHeight: icn.height
    property bool iconCenter: false

    property bool press: marea.pressed
    property bool enter: marea.containsMouse

    property color highlightColor: masterPalette.highlight
    property string normalColor: "#00000000"
    property string hoverColor: normalColor

    property alias textColor: txt.color

    property alias cursorShape: marea.cursorShape
    property real textMargin: 0

    property color tooltipColor: "#cc000000"
    property color tooltipTextColor: "#ffffff"
    property font tooltipFont
    property string tooltipText

    signal clicked()

    Row {
        id: row
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 3*1
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 1

        Image {
            id: icn
            anchors.verticalCenter: parent.verticalCenter
            height: source==""? 0 : parent.height-14*Devices.density
            width: height
            sourceSize.width: width
            sourceSize.height: height
            smooth: true
        }

        Text{
            id: txt
            y: parent.height/2 - height/2 - textMargin
            color: "#ffffff"

            font.pixelSize: Math.floor(9*1)
        }
    }

    MouseArea{
        id: marea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: button.clicked()
        onEntered: if( !tooltipItem && tooltipText.length != 0 ) tooltipItem = tooltip_component.createObject(button)
        onExited: if( tooltipItem ) tooltipItem.end()

        property variant tooltipItem
    }

    Component {
        id: tooltip_component

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.margins: 2*Devices.density
            color: tooltipColor
            width: tooltip_txt.width + 14*Devices.density
            height: tooltip_txt.height + 14*Devices.density
            radius: 3*Devices.density

            Text {
                id: tooltip_txt
                anchors.centerIn: parent
                font: tooltipFont
                color: tooltipTextColor
                text: tooltipText
            }

            function end() {
                destroy()
            }
        }
    }
}
