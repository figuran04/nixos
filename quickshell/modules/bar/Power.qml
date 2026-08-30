import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services

StyledRect {
    id: root

    required property var popoutState

    color: Colours.palette.m3surfaceContainer
    radius: Tokens.rounding.full
    implicitWidth: Tokens.sizes.bar.innerWidth
    implicitHeight: Tokens.sizes.bar.innerWidth

    readonly property int entry: Tokens.sizes.bar.innerWidth - Tokens.padding.medium * 2

    MaterialIcon {
        anchors.centerIn: parent
        text: "power_settings_new"
        color: Colours.palette.m3secondary
        fontStyle: Tokens.font.icon
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: parent.opacity = 0.7
        onExited: parent.opacity = 1
        onClicked: root.popoutState.request("power")
    }

    Behavior on opacity {
        Anim { type: Anim.DefaultEffects }
    }
}
