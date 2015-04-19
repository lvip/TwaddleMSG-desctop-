


import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtWebKit 3.0



    ScrollView {
        width: parent.width
        height:parent.height
        WebView {
            id: webview
            url: "http://youtube.ru"
            anchors.fill: parent
            onNavigationRequested: {
                // detect URL scheme prefix, most likely an external link
                var schemaRE = /^\w+:/;
                if (schemaRE.test(request.url)) {
                    request.action = WebView.AcceptRequest;
                } else {
                    request.action = WebView.IgnoreRequest;
                    // delegate request.url here
                }
            }
        }
    }

