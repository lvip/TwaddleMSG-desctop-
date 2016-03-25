
import QtQuick 2.3
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.1
  Item{
      id:com1
    Component.onDestruction: console.log("destroyed inline item: " + stackView.index)
    Rectangle
    {
       anchors.fill: parent
       color: "#11ffffff"
    }

TabView{
    anchors.fill: parent
    style:tabViewStyle
    Tab{
        title: "Контакты"
        ContactList{id: contatlisttab

        }

    }
    Tab
    {
        title: "Последнии"

    }
}
property Component tabViewStyle: TabViewStyle {
    //tabOverlap: 16
    //frameOverlap: 4
    //tabsMovable: true

    frame: Rectangle {
        gradient: Gradient {
            GradientStop { color: "#e5e5e5" ; position: 0 }
            GradientStop { color: "#e0e0e0" ; position: 1 }
        }
    }
    leftCorner: Item { implicitWidth: 12 }
}
}
