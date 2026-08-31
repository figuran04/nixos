import QtQuick
import QtQuick.Controls
import "../components"
import "../services"

// A clickable, hoverable icon button used throughout the dock.
Item {
    id: root

    signal clicked()

    property string icon: ""
    property color colour: Colours.palette.m3onSurfaceVariant
    property int size: Tokens.sizes.bar.iconSize
    property int pad: Tokens.padding.small
    property bool active: false

    implicitWidth: root.active ? 3 + root.size + root.pad * 2 : root.size + root.pad * 2
    implicitHeight: root.size + root.pad * 2

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Tokens.rounding.medium
        color: "transparent"

        Behavior on color {
            ColorAnimation { duration: Tokens.anim.durations.fast }
        }
    }

    MaterialIcon {
        id: img
        anchors.centerIn: parent
        icon: root.icon
        iconSize: root.size
        iconColor: root.active ? Colours.palette.m3primary : bgHover.containsMouse ? Colours.palette.m3onSurface : root.colour
    }

    // active indicator
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        width: 3
        height: root.size * 0.5
        radius: Math.floor(height / 2)
        color: root.active ? Colours.palette.m3primary : "transparent"
        visible: root.active
    }

    HoverHandler {
        id: bgHover
        hoverEnabled: true
    }

    TapHandler {
        onTapped: root.clicked()
    }

    onActiveChanged: bg.color = root.active ? Colours.withAlpha(Colours.palette.m3primary, 0.12) : "transparent"
    onColourChanged: bg.color = root.active ? Colours.withAlpha(Colours.palette.m3primary, 0.12) : "transparent"

    states: State {
        name: "hovered"
        when: bgHover.hovered
        PropertyChanges { target: bg; color: Colours.withAlpha(Colours.palette.m3onSurface, 0.06) }
    }
}
