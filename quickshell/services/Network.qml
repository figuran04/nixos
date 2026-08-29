pragma Singleton
import Quickshell
import Quickshell.Networking
import QtQuick

Singleton {
  readonly property bool enabled: Networking.wifiEnabled
  readonly property var wifi: {
    for (let i = 0; i < Networking.devices.count; i++) {
      const d = Networking.devices.get(i);
      if (d.mode !== undefined)
        return d;
    }
    return null;
  }
  readonly property string ssid: wifi != null && wifi.activeConnection != null ? wifi.activeConnection.id : ""

  function toggle() {
    Networking.wifiEnabled = !Networking.wifiEnabled;
  }
}
