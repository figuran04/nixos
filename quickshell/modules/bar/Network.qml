import QtQuick
import "../../services"

MouseArea {
  id: root
  implicitHeight: 20
  implicitWidth: row.width
  onClicked: Net.toggle()

  Row {
    id: row
    spacing: 4
    anchors.verticalCenter: parent.verticalCenter

    Text {
      text: Net.enabled ? "Wifi" : "Off"
      color: Net.enabled ? "#cdd6f4" : "#f38ba8"
      font.pixelSize: 13
    }
    Text {
      visible: Net.ssid !== ""
      text: Net.ssid
      color: "#a6adc8"
      font.pixelSize: 13
    }
  }
}
