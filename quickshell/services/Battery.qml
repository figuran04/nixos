pragma Singleton
import Quickshell
import Quickshell.Services.UPower
import QtQuick

Singleton {
  readonly property UPowerDevice device: UPower.displayDevice
  readonly property bool hasBattery: device != null && device.isLaptopBattery
  readonly property real percentage: device != null ? device.percentage : 0
  readonly property bool charging: device != null && device.state == UPowerDeviceState.Charging
}
