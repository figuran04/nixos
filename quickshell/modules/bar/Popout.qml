import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../services"
import "./popouts" as Popouts

StyledClippingRect {
    id: root

    required property var popoutState
    property var screen

    visible: popoutState.hasCurrent
    opacity: visible ? 1 : 0

    Behavior on opacity {
        Anim { type: Anim.DefaultEffects }
    }

    radius: Tokens.rounding.extraLarge
    color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 0.96)

    implicitWidth: inner.implicitWidth + Tokens.padding.large * 2
    implicitHeight: inner.implicitHeight + Tokens.padding.large * 2

    ColumnLayout {
        id: inner

        x: Tokens.padding.large
        y: Tokens.padding.large

        Loader {
            id: loader

            active: root.visible
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
    Component { id: compPower; Popouts.PowerPopout { screen: root.screen; popoutState: root.popoutState } }
}
