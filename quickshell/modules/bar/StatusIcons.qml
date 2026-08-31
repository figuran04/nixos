import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../services"

StyledRect {
    id: root

    required property var popoutState

    color: Colours.palette.m3surfaceContainer
    radius: Tokens.rounding.full
    implicitWidth: Tokens.sizes.bar.innerWidth
    implicitHeight: col.implicitHeight + Tokens.padding.medium * 2

    readonly property int entry: Tokens.sizes.bar.innerWidth - Tokens.padding.medium * 2

    ColumnLayout {
        id: col

        anchors.fill: parent
        anchors.margins: Tokens.padding.medium
        spacing: Tokens.spacing.medium

        Entry {
            icon: Icons.getVolumeIcon(Audio.volume, Audio.muted)
            colour: Colours.palette.m3secondary
            action: () => root.popoutState.request("audio", "left")
        }

        Entry {
            icon: Network.enabled ? (Network.ssid ? "wifi" : "wifi_find") : "wifi_off"
            colour: Colours.palette.m3secondary
            action: () => root.popoutState.request("network", "left")
        }

        Entry {
            icon: Bluetooth.enabled ? "bluetooth" : "bluetooth_disabled"
            colour: Bluetooth.enabled ? Colours.palette.m3secondary : Colours.palette.m3onSurfaceVariant
            action: () => root.popoutState.request("bluetooth", "left")
        }

        Entry {
            icon: Icons.getBatteryIcon(Battery.percentage, Battery.charging)
            colour: Colours.palette.m3secondary
            visible: Battery.hasBattery
            action: () => root.popoutState.request("battery", "left")
        }

        Entry {
            icon: "headphones"
            colour: Colours.palette.m3secondary
            visible: Media.player != null
            action: () => root.popoutState.request("media", "left")
        }

        Entry {
            icon: "content_paste"
            colour: Colours.palette.m3secondary
            visible: Clipboard.entries.length > 0
            action: () => root.popoutState.request("clipboard", "left")
        }

        Entry {
            icon: "monitor_heart"
            colour: Colours.palette.m3primary
            action: () => root.popoutState.request("dashboard", "left")
        }
    }

    component Entry: Item {
        required property string icon
        required property color colour
        required property var action

        implicitWidth: root.entry
        implicitHeight: root.entry

        MaterialIcon {
            anchors.centerIn: parent
            text: parent.icon
            color: parent.colour
            fontStyle: Tokens.font.icon
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.opacity = 0.7
            onExited: parent.opacity = 1
            onClicked: parent.action()
        }

        Behavior on opacity {
            Anim { type: Anim.DefaultEffects }
        }
    }
}
