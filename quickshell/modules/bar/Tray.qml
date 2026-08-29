import QtQuick
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Row {
  spacing: 6

  Repeater {
    model: SystemTray.items

    IconImage {
      source: modelData.icon
      implicitWidth: 16
      implicitHeight: 16

      MouseArea {
        anchors.fill: parent
        onClicked: modelData.activate()
      }
    }
  }
}
