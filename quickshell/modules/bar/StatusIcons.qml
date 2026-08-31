import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../services"
import "./"

// Clickable status icons in the dock, each toggling a popout panel.
ColumnLayout {
    id: root

    spacing: Tokens.spacing.small

    property QtObject store: null

    Entry {
        icon: Icons.getVolumeIcon(Audio.volume, Audio.muted)
        colour: Colours.palette.m3secondary
        active: root.store ? root.store.currentName === "audio" : false
        onClicked: root.store.request("audio", "left")
    }

    Entry {
        icon: Icons.getNetworkIcon(Network.enabled, Network.connected, Network.signal / 100)
        colour: Colours.palette.m3secondary
        active: root.store ? root.store.currentName === "network" : false
        onClicked: root.store.request("network", "left")
    }

    Entry {
        icon: Bluetooth.enabled ? "bluetooth" : "bluetooth_disabled"
        colour: Bluetooth.enabled ? Colours.palette.m3secondary : Colours.palette.m3onSurfaceVariant
        active: root.store ? root.store.currentName === "bluetooth" : false
        onClicked: root.store.request("bluetooth", "left")
    }

    Entry {
        icon: Icons.getBatteryIcon(Battery.percentage, Battery.charging)
        colour: Colours.palette.m3secondary
        active: root.store ? root.store.currentName === "battery" : false
        visible: Battery.hasBattery
        onClicked: root.store.request("battery", "left")
    }

    Entry {
        icon: "headphones"
        colour: Colours.palette.m3secondary
        active: root.store ? root.store.currentName === "media" : false
        visible: Media.player != null
        onClicked: root.store.request("media", "left")
    }

    Entry {
        icon: "content_paste"
        colour: Colours.palette.m3secondary
        active: root.store ? root.store.currentName === "clipboard" : false
        visible: Clipboard.entries.length > 0
        onClicked: root.store.request("clipboard", "left")
    }

    Entry {
        icon: "monitor_heart"
        colour: Colours.palette.m3primary
        active: root.store ? root.store.currentName === "dashboard" : false
        onClicked: root.store.request("dashboard", "left")
    }
}
