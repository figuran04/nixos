import Quickshell
import QtQuick
import "../components"
import "../services"

// Floating panel that appears to the left of the dock when a popout opens.
// The concave corners face right (toward the dock), matching Noctalia.
PanelWindow {
    id: root

    property QtObject store: null

    readonly property bool isOpen: root.store ? root.store.hasCurrent : false
    readonly property string current: root.store ? root.store.currentName : ""
    property real concaveR: Tokens.rounding.medium
    property real cornerR: Tokens.rounding.extraLarge
    property real sideGap: 8

    // Reserve space for the dock on the right edge.
    readonly property real dockReserve: Tokens.sizes.bar.innerWidth + Tokens.padding.large * 2 + Tokens.padding.medium * 2

    anchors.top: true
    anchors.right: true
    margins.right: root.dockReserve + root.sideGap

    color: "transparent"
    exclusiveZone: 0

    implicitWidth: 360
    implicitHeight: Tokens.sizes.bar.innerWidth + Tokens.padding.large * 2

    visible: root.isOpen
    opacity: root.isOpen ? 1 : 0

    Behavior on opacity {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing.type: Tokens.anim.expressiveDefaultSpatial }
    }

    AdaptiveRoundedRect {
        id: bg
        anchors.fill: parent

        color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 0.96)
        borderColor: Colours.withAlpha(Colours.palette.m3outline, 0.35)
        borderWidth: 1
        tlRadius: root.cornerR
        trRadius: root.isOpen ? 0 : root.cornerR
        blRadius: root.cornerR
        brRadius: root.isOpen ? 0 : root.cornerR
        trConcave: root.isOpen ? root.concaveR : 0
        brConcave: root.isOpen ? root.concaveR : 0

        Loader {
            id: contentLoader
            anchors.fill: parent
            anchors.margins: Tokens.padding.medium
            sourceComponent: {
                switch (root.current) {
                case "audio": return audioComponent;
                case "network": return networkComponent;
                case "bluetooth": return bluetoothComponent;
                case "battery": return batteryComponent;
                case "media": return mediaComponent;
                case "clipboard": return clipboardComponent;
                case "dashboard": return dashboardComponent;
                case "power": return powerComponent;
                default: return null;
                }
            }
        }
    }

    Component { id: audioComponent; AudioPopout {} }
    Component { id: networkComponent; NetworkPopout {} }
    Component { id: bluetoothComponent; BluetoothPopout {} }
    Component { id: batteryComponent; BatteryPopout {} }
    Component { id: mediaComponent; MediaPopout {} }
    Component { id: clipboardComponent; ClipboardPopout {} }
    Component { id: dashboardComponent; DashboardPopout {} }
    Component { id: powerComponent; PowerPopout {} }
}
