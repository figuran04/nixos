pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    readonly property UPowerDevice device: UPower.displayDevice
    readonly property bool hasBattery: root.device != null && root.device.isPresent
    readonly property real percentage: root.hasBattery ? root.device.percentage : 0
    readonly property bool charging: root.device != null && (root.device.state === UPowerDeviceState.Charging || root.device.state === UPowerDeviceState.FullyCharged)
    readonly property bool onBattery: UPower.onBattery
}
