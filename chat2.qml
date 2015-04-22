import QtQuick 2.3

 Item {
    id: resizeRectItem
    property real rectWidth
    property real rectHeight

    rectWidth: rightWall.x - leftWall.x
    rectHeight: bottomWall.y - topWall.y
    //opacity: 1

    Rectangle {
        id: resizeRect
        width: rectWidth
        height: rectHeight
        color: "blue"
        anchors.right: rightWall.left
        anchors.bottom: bottomWall.top
        anchors.top: topWall.bottom
        anchors.left: leftWall.right
    }
    MouseArea {
        id: resizeRectDragMA
        width: rectWidth -5
        height: rectHeight -5
        anchors.centerIn: parent
        drag.target: resizeRectItem
        drag.axis: Drag.XandYAxis

        onPressed: {
            resizeRect.color = "green"
            resizeRectItem.anchors.centerIn = null
        }
        onReleased: {
            resizeRect.color = "blue"
        }
    }

    Rectangle {
        id: topWall
        x: -100
        y: -100
        width: rectWidth
        height: 4
        color: "red"
    }
    MouseArea {
        id: topWallMA
        anchors.fill: topWall
        drag.target: topWall
        drag.axis: Drag.YAxis
        onPressed: {
            leftWall.anchors.top = topWall.bottom
            rightWall.anchors.top = topWall.bottom
        }
    }
    Rectangle {
        id: bottomWall
        x:-100
        y: 100
        width: rectWidth
        height: 4
        color: "purple"
    }
    MouseArea {
        id: bottomWallMA
        anchors.fill: bottomWall
        drag.target: bottomWall
        drag.axis: Drag.YAxis
        onPressed: {
            leftWall.anchors.bottom = bottomWall.top
            rightWall.anchors.bottom = bottomWall.top
        }
    }
    Rectangle {
        id: leftWall
        x: -100
        y: -100
        width: 4
        height: rectHeight
        color: "yellow"
    }
    MouseArea {
        id: leftWallMA
        anchors.fill: leftWall
        drag.target: leftWall
        drag.axis: Drag.XAxis
        onPressed: {
            if(resizeRectItem)
            topWall.anchors.left = leftWall.right
            bottomWall.anchors.left = leftWall.right
        }
    }
    Rectangle {
        id: rightWall
        x: 100
        y: -100
        width: 4
        height: rectHeight
        color: "orange"
    }
    MouseArea {
        id: rightWallMA
        anchors.fill: rightWall
        drag.target: rightWall
        drag.axis: Drag.XAxis
        onPressed: {
            topWall.anchors.right = rightWall.left
            bottomWall.anchors.right = rightWall.left
        }
    }
    states: [
        State {
             name: "hide"
             PropertyChanges {
                 target: resizeRectItem
                 opacity: 0.0
             }
        }
    ]
}
