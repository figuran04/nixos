import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../services"
import "./popouts" as Popouts

Item {
    id: root

    required property var popoutState
    property var screen

    readonly property bool isOpen: popoutState.hasCurrent
    readonly property real cornerR: Tokens.rounding.extraLarge
    readonly property real concaveR: Tokens.rounding.medium

    implicitWidth: body.implicitWidth + Tokens.padding.large * 2
    implicitHeight: body.implicitHeight + Tokens.padding.large * 2

    // Background is always drawn (fully-rounded). The corner cut-outs are
    // driven by isOpen so the panel visibly unwraps/match the dock.
    AdaptiveRoundedRect {
        id: bg

        anchors.fill: parent

        color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 0.96)
        tlRadius: root.cornerR
        trRadius: root.cornerR
        blRadius: root.cornerR
        brRadius: root.cornerR
        trConcave: root.isOpen ? root.concaveR : 0
        brConcave: root.isOpen ? root.concaveR : 0
    }

    ColumnLayout {
        id: body

        x: Tokens.padding.large
        y: Tokens.padding.large

        Loader {
            id: loader

            active: root.isOpen
            sourceComponent: {
                switch (popoutState.currentName) {
                case "audio":
                    return compAudio;
                case "network":
                    return compNetwork;
                case "bluetooth":
                    return compBluetooth;
                case "battery":
                    return compBattery;
                case "media":
                    return compMedia;
                case "clipboard":
                    return compClipboard;
                case "dashboard":
                    return compDashboard;
                case "power":
                    return compPower;
                }
                return null;
            }
        }
    }

    Component { id: compAudio; Popouts.AudioPopout {} }
    Component { id: compNetwork; Popouts.NetworkPopout {} }
    Component { id: compBluetooth; Popouts.BluetoothPopout {} }
    Component { id: compBattery; Popouts.BatteryPopout {} }
    Component { id: compMedia; Popouts.MediaPopout {} }
    Component { id: compClipboard; Popouts.ClipboardPopout {} }
    Component { id: compDashboard; Popouts.DashboardPopout {} }
    Component { id: compPower; Popouts.PowerPopout { screen: root.screen; popoutState: root.popoutState } }
}
