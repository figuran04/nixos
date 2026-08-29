import QtQuick
import "../../services"

MouseArea {
  id: root
  implicitHeight: 20
  implicitWidth: row.width
  onClicked: Audio.toggleMute()
  onWheel: (wheel) => Audio.setVolume(Audio.volume + (wheel.angleDelta.y > 0 ? 0.05 : -0.05))

  Row {
    id: row
    spacing: 4
    anchors.verticalCenter: parent.verticalCenter

    Text {
      text: Audio.muted ? "Vol (muted)" : "Vol"
      color: Audio.muted ? "#f38ba8" : "#cdd6f4"
      font.pixelSize: 13
    }
    Text {
      text: Math.round(Audio.volume * 100) + "%"
      color: "#a6adc8"
      font.pixelSize: 13
    }
  }
}
