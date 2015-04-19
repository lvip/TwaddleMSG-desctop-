
import QtQuick 2.3
import QtQuick.Controls 1.3
FocusScope {
    id: focusScope
    width: 250; height: 70

    property string text: textInput.text
    signal clear
    onClear: {
        textInput.text=""
    }



    BorderImage {
        source: "/images/images/lineedit-bg.png"
        width: parent.width; height: parent.height
        border { left: 4; top: 4; right: 4; bottom: 4 }
    }

    Text {
        id: typeSomething
        anchors.fill: parent; anchors.leftMargin: 8
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WrapAnywhere
        text: "Type something..."
        color: "gray"
        font.italic: true
        font.pointSize: 14
    }

    MouseArea {
        anchors.fill: parent
        onClicked: { focusScope.focus = true; }
    }

    TextInput {
        id: textInput
        anchors { left: parent.left; leftMargin: 8; right: clear.left; rightMargin: 8; verticalCenter: parent.verticalCenter }
        focus: true
        wrapMode: Text.WrapAnywhere
        selectByMouse: true
        font.pointSize: 19
    }

    Image {
        id: clear
        anchors { right: parent.right; rightMargin: 8; verticalCenter: parent.verticalCenter }
        source: "/images/images/clear.png"
        opacity: 0

        MouseArea {
            // allow area to grow beyond image size
            // easier to hit the area on high DPI devices
            anchors.centerIn: parent
            height:focusScope.height
            width: focusScope.height
            onClicked: {
                //toogle focus to be able to jump out of input method composer
                focusScope.focus = false;
                textInput.text = '';
                focusScope.focus = true;
            }
        }
    }

    states: State {
        name: "hasText"; when: (textInput.text != '' || textInput.inputMethodComposing)
        PropertyChanges { target: typeSomething; opacity: 0 }
        PropertyChanges { target: clear; opacity: 1 }
    }

    transitions: [
        Transition {
            from: ""; to: "hasText"
            NumberAnimation { exclude: typeSomething; properties: "opacity" }
        },
        Transition {
            from: "hasText"; to: ""
            NumberAnimation { properties: "opacity" }
        }
    ]
}
