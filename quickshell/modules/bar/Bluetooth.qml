import QtQuick
import "../../services"

Text {
  text: Bt.enabled ? "BT" + (Bt.connected > 0 ? " " + Bt.connected : "") : "BT off"
  color: Bt.enabled ? "#cdd6f4" : "#6c7086"
  font.pixelSize: 13
}
