import QtQuick
import "../components"
import "../services"

// Renders a Material Symbols glyph given its name.
// Requires the "Material Symbols Outlined" font (installed on the system).
Text {
    id: root

    property string icon: ""
    property int iconSize: Tokens.sizes.bar.iconSize
    property color iconColor: Colours.palette.m3onSurface

    readonly property string _glyph: {
        // Resolve the glyph codepoint for the requested icon name; fall back
        // to the name itself if unknown so nothing silently goes blank.
        return root.icon === "" ? " " : root._codepointFor(root.icon);
    }

    function _codepointFor(name) {
        const map = {
            "volume_off": "\ue04c", "volume_mute": "\ue04e", "volume_down": "\ue04d", "volume_up": "\ue050",
            "battery_charging_full": "\ue1a3", "battery_full": "\ue1a4", "battery_5_bar": "\ue1a2",
            "battery_4_bar": "\ue1a1", "battery_3_bar": "\ue1a0", "battery_2_bar": "\ue19f",
            "battery_1_bar": "\ue19e", "battery_alert": "\ue19c",
            "wifi": "\ue63e", "wifi_2_bar": "\ue640", "wifi_1_bar": "\ue641", "wifi_0_bar": "\ue642",
            "wifi_find": "\uf1c6", "wifi_off": "\ue647", "signal_wifi_off": "\ue63d",
            "bluetooth": "\ue1a7", "bluetooth_disabled": "\ue1a9",
            "headphones": "\ue333", "monitor_heart": "\ueaa2",
            "play_arrow": "\ue037", "pause": "\ue034", "skip_previous": "\ue045", "skip_next": "\ue044",
            "lock": "\ue897", "logout": "\ue9ba", "power": "\ue63c",
            "delete": "\ue872", "copy": "\ue14d",
            "memory": "\ue322", "star": "\ue838", "person": "\ue7fd", "home": "\ue88a",
            "content_paste": "\ue0f8", "power_settings_new": "\ue8ac",
            "keyboard_arrow_left": "\ue314", "keyboard_arrow_right": "\ue315",
            "brightness_high": "\ue1ae", "brightness_low": "\ue1ad",
            "lock": "\ue897", "notifications": "\ue7f5", "menu": "\ue5d2",
            "search": "\ue8b6", "close": "\ue5cd", "refresh": "\ue5d5"
        };
        return map[name] !== undefined ? map[name] : name;
    }

    text: root._glyph
    font.family: "Material Symbols Outlined"
    font.pixelSize: root.iconSize
    color: root.iconColor
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter

    Behavior on color {
        ColorAnimation { duration: Tokens.anim.durations.fast }
    }
}
