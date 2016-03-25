import QtQuick 2.6
import QtQuick.Controls 1.5 as Controls
Rectangle {
    width: 400
    height: 600


    Column {
        anchors.centerIn: parent
        anchors.alignWhenCentered: true
        TextField {
            id: nameInput
            onAccepted: passwordInput.forceActiveFocus()
            placeholderText: "Username"
            KeyNavigation.tab: passwordInput
        }

        TextField {
            id: passwordInput
            onAccepted: login()
            placeholderText: "Password"
            echoMode: TextInput.Password
            KeyNavigation.tab: loginButton
        }

        Row {
            // button
            width: 360 * scaleFactor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.alignWhenCentered: true
            TouchButton {
                id: loginButton
                text: "Login"
                baseColor: "#7a5"
                width: (parent.width - parent.spacing)/2
                onClicked: login()
                enabled: nameInput.text.length && passwordInput.text.length
                KeyNavigation.tab: registerButton
            }
            TouchButton {
                id: registerButton
                text: "Register"
                onClicked: registerAndLogin()
                width: (parent.width - parent.spacing)/2
                enabled:  nameInput.text.length && passwordInput.text.length
                KeyNavigation.tab: nameInput
            }
        }
    }

    Text {
        id: statusText
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 70 * scaleFactor
        font.pixelSize: 18 * scaleFactor
        color: "#444"
    }
    function login() {
        stackView2.opacity=0
        stackView2.z=-3
        stackView2.visible=false
        stackView2.focus=false
        header1.opacity=1
        header1.z=5
        stackView.visible=true
        stackView.focus=true
        stackView.opacity=1
        stackView.z=1000
    }

}
