import QtQuick
import "../../services"

Text {
  visible: Battery.hasBattery
  text: (Battery.charging ? "Charging " : "") + Math.round(Battery.percentage) + "%"
  color: "#cdd6f4"
  font.pixelSize: 13
}
