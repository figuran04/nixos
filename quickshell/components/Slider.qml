import QtQuick
import qs.components
import qs.services

Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 1
    property color color: Colours.palette.m3primary
    signal moved(real v)

    implicitWidth: 200
    implicitHeight: 24

    readonly property real frac: Math.max(0, Math.min(1, (root.value - root.from) / (root.to - root.from)))

    function clamp(v: real): real {
        return Math.max(0, Math.min(1, v));
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 6
        radius: 9999
        color: Colours.palette.m3surfaceContainerHighest
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width * root.frac
        height: 6
        radius: 9999
        color: root.color
    }

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        x: parent.width * root.frac - 8
        width: 16
        height: 16
        radius: 9999
        color: root.color

        Behavior on x {
            Anim { type: Anim.DefaultSpatial }
        }
    }

    MouseArea {
        anchors.fill: parent

        onPositionChanged: mouse => {
            if (pressed)
                root.moved(root.from + clamp(mouse.x / parent.width) * (root.to - root.from));
        }
        onPressed: mouse => {
            root.moved(root.from + clamp(mouse.x / parent.width) * (root.to - root.from));
        }
    }
}
