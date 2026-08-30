pragma Singleton
import Quickshell
import Quickshell.Bluetooth
import QtQuick

Singleton {
  readonly property bool enabled: Bluetooth.defaultAdapter != null && Bluetooth.defaultAdapter.powered
  readonly property int connected: Bluetooth.devices?.count ?? 0
}
