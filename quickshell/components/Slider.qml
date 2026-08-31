import QtQuick
import "../services"
import "../components"

// Minimal vertical slider used for volume / brightness control in popouts.
Item {
    id: root

    signal moved(real value)

    property real value: 0
    property real from: 0
    property real to: 100
    property int handleSize: 14
    property string icon: ""

    implicitWidth: Tokens.sizes.bar.innerWidth
    implicitHeight: 200

    function setValue(v) {
        root.value = Math.max(root.from, Math.min(root.to, v));
    }

    Item {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: root.handleSize + 20

        Rectangle {
            id: track
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 6
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            width: 6
            radius: 3
            color: Colours.withAlpha(Colours.palette.m3onSurfaceVariant, 0.3)
        }

        Rectangle {
            id: fill
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: track.bottom
            width: 6
            radius: 3
            height: track.height * (root.to === root.from ? 0 : (root.value - root.from) / (root.to - root.from))
            color: Colours.palette.m3primary
        }

        Rectangle {
            id: handle
            anchors.horizontalCenter: parent.horizontalCenter
            y: track.bottom - root.handleSize / 2 - (track.height * (root.to === root.from ? 0 : (root.value - root.from) / (root.to - root.from)))
            width: root.handleSize
            height: root.handleSize
            radius: Math.floor(root.handleSize / 2)
            color: Colours.palette.m3onSurface
            border.color: Colours.palette.m3primary
            border.width: 2
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                const frac = 1 - (mouseY - track.y) / Math.max(1, track.height);
                root.setValue(root.from + (root.to - root.from) * Math.max(0, Math.min(1, frac)));
                root.moved(root.value);
            }
            onPositionChanged: {
                if (pressed) {
                    const frac = 1 - (mouseY - track.y) / Math.max(1, track.height);
                    root.setValue(root.from + (root.to - root.from) * Math.max(0, Math.min(1, frac)));
                    root.moved(root.value);
                }
            }
        }
    }
}
