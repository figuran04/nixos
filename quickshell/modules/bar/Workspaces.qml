import QtQuick
import Quickshell.Io

Row {
  spacing: 6

  // Niri has no dedicated Quickshell module, so we talk to it over its
  // JSON IPC (`niri msg -j workspaces`) and switch via `focus-workspace`.
  property var workspaces: []

  Repeater {
    model: workspaces

    Rectangle {
      required property var modelData
      width: 22
      height: 22
      radius: 4
      color: modelData.is_active ? "#89b4fa" : "#313244"

      Text {
        anchors.centerIn: parent
        text: String(modelData.idx + 1)
        color: modelData.is_active ? "#11111b" : "#cdd6f4"
        font.pixelSize: 12
      }

      MouseArea {
        anchors.fill: parent
        onClicked: wsProc.command = ["niri", "msg", "action", "focus-workspace", "--workspace", String(modelData.idx + 1)]
      }
    }
  }

  Process {
    id: wsProc
    running: true
    command: ["niri", "msg", "-j", "workspaces"]
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          parent.workspaces = JSON.parse(this.text)
        } catch (e) {}
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: wsProc.running = true
  }
}
