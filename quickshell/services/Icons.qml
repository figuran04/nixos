pragma Singleton

import Quickshell
import QtQuick

// Helper mapping for Material Symbols icons used across the shell.
Singleton {
    id: root

    function getVolumeIcon(volume, muted) {
        if (muted || volume <= 0) return "volume_off";
        if (volume < 0.35) return "volume_mute";
        if (volume < 0.7) return "volume_down";
        return "volume_up";
    }

    function getBatteryIcon(percent, charging) {
        if (charging) return "battery_charging_full";
        if (percent >= 90) return "battery_full";
        if (percent >= 70) return "battery_5_bar";
        if (percent >= 50) return "battery_4_bar";
        if (percent >= 30) return "battery_3_bar";
        if (percent >= 15) return "battery_2_bar";
        if (percent > 0) return "battery_1_bar";
        return "battery_alert";
    }

    function getNetworkIcon(enabled, connected, signal) {
        if (!enabled) return "signal_wifi_off";
        if (!connected) return "wifi_find";
        if (signal >= 0.75) return "wifi";
        if (signal >= 0.5) return "wifi_2_bar";
        if (signal >= 0.25) return "wifi_1_bar";
        return "wifi_0_bar";
    }
}
