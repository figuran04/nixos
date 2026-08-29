import Quickshell
import QtQuick
import QtQuick.Layouts
import "./bar"
import "../../services"

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors.top: true
      anchors.left: true
      anchors.right: true
      implicitHeight: 30
      color: "#1e1e2e"

      RowLayout {
        anchors.fill: parent
        spacing: 10

        Workspaces {}
        Item { Layout.fillWidth: true }

        Clock {}
        Media {}
        Audio {}
        Network {}
        Bluetooth {}
        Battery {}
        Tray {}
      }
    }
  }
}
