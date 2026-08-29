import QtQuick
import "../../services"

MouseArea {
  id: root
  implicitHeight: 20
  implicitWidth: row.width
  onClicked: Network.toggle()

  Row {
    id: row
    spacing: 4
    anchors.verticalCenter: parent.verticalCenter

    Text {
      text: Network.enabled ? "Wifi" : "Off"
      color: Network.enabled ? "#cdd6f4" : "#f38ba8"
      font.pixelSize: 13
    }
    Text {
      visible: Network.ssid !== ""
      text: Network.ssid
      color: "#a6adc8"
      font.pixelSize: 13
    }
  }
}
