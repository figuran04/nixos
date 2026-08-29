import QtQuick
import "../../services"

MouseArea {
  visible: Media.player != null
  implicitHeight: 20
  implicitWidth: row.width
  onClicked: if (Media.player != null) Media.player.togglePlaying()

  Row {
    id: row
    spacing: 6
    anchors.verticalCenter: parent.verticalCenter

    Text {
      text: Media.player != null && Media.player.isPlaying ? ">" : "||"
      color: "#cdd6f4"
      font.pixelSize: 13
    }
    Text {
      text: Media.player != null ? (Media.player.trackTitle || "Unknown") : ""
      color: "#cdd6f4"
      font.pixelSize: 13
    }
    Text {
      text: Media.player != null ? (Media.player.trackArtist || "") : ""
      color: "#a6adc8"
      font.pixelSize: 12
    }
  }
}
