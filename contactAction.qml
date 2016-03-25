





import QtQuick 2.6

Item {
    id: root
    width: parent.width
    height: 88

    property alias text: textitem.text
    signal clicked
    MouseArea {
        property bool ent: false
        id: moousearea
        anchors.fill: parent
        onEntered: {
            ent = true
        }
        onExited: {
            ent = false
            effect.angle = 0.0
        }
        hoverEnabled: true
    }

    Rectangle {
        anchors.fill: parent
        color: "#33ff0000"
        visible: mouse.pressed
    }
    Rectangle {
        anchors.fill: parent
        color: "lightblue"
    }
    Rectangle {
        id:borderec
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        width: img1.width+17
        height: img1.height+17
        radius: 30
        z:100
        color: "#00ffffff"
        border.width: 7
        border.color: "lightblue"

    }
    Image
    {   id:img1
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 8
        source: "/images/images/msDefaultPicture.png"
    }
    ShaderEffectSource {
        id:theSource
        recursive: true
        sourceItem: img1
        hideSource: true
    }
    Text {
        id: textitem
        color: "white"
        font.pixelSize: 32
        text: modelData
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: img1.right
        anchors.leftMargin: 30
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 15
        height: 1
        color: "#424246"
    }



    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: root.clicked()

    }
    ShaderEffect {
        property variant source: theSource
        id: effect
        anchors.fill:   img1
        property real angle : 0.0
        PropertyAnimation on angle {
            id: prop1
            from:0.0
            to: 360.0
            duration: 800
            loops: Animation.Infinite
            running: moousearea.ent
        }

        fragmentShader: "
         varying highp vec2 qt_TexCoord0;
         uniform lowp sampler2D source;
         uniform highp float angle;
         void main() {
          highp float wave = 0.02;
          highp float wave_x = qt_TexCoord0.x + wave * sin( radians( angle + qt_TexCoord0.x * 360.0 ) );
          highp float wave_y = qt_TexCoord0.y + wave * sin( radians( angle + qt_TexCoord0.y * 360.0 ) );
          highp vec4 texpixel = texture2D( source, vec2( wave_x, wave_y ) );
          gl_FragColor = texpixel;
        }"
    }

}

