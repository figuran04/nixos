import QtQuick
import "../../services"

Text {
  text: Time.time + "  " + Time.date
  color: "#cdd6f4"
  font.pixelSize: 13
}
