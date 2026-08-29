import QtQuick
import "../../services"

Text {
  text: Bluetooth.enabled ? "BT" + (Bluetooth.connected > 0 ? " " + Bluetooth.connected : "") : "BT off"
  color: Bluetooth.enabled ? "#cdd6f4" : "#6c7086"
  font.pixelSize: 13
}
