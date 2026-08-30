pragma Singleton
import Quickshell
import QtQuick

// Material Symbols glyph helpers (ligature names).
Singleton {
    id: root

    function getVolumeIcon(volume: real, muted: bool): string {
        if (muted || volume <= 0)
            return "volume_off";
        if (volume < 0.33)
            return "volume_mute";
        if (volume < 0.67)
            return "volume_down";
        return "volume_up";
    }

    function getNetworkIcon(strength: int): string {
        if (strength >= 80)
            return "wifi";
        if (strength >= 55)
            return "wifi_2_bar";
        if (strength >= 30)
            return "wifi_1_bar";
        return "wifi";
    }

    function getBatteryIcon(percentage: real, charging: bool): string {
        const p = Math.round(percentage);
        const base = charging ? "battery_charging_" : "battery_";
        if (p >= 95) return base + "full";
        if (p >= 75) return base + "4_bar";
        if (p >= 50) return base + "3_bar";
        if (p >= 25) return base + "2_bar";
        if (p >= 10) return base + "1_bar";
        return base + "0_bar";
    }
}
