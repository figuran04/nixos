import Quickshell
import QtQuick
import Quickshell.Services.Notifications

Scope {
  NotificationServer {
    id: server
    onNotification: (n) => n.tracked = true
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors.top: true
      anchors.right: true
      implicitWidth: 320
      implicitHeight: col.implicitHeight + 16
      color: "#11111b"

      Column {
        id: col
        x: 8
        y: 8
        width: parent.width - 16
        spacing: 8

        Repeater {
          model: server.trackedNotifications

          delegate: Item {
            required property var modelData
            width: col.width
            implicitHeight: txt.height + 8

            Rectangle {
              anchors.fill: parent
              radius: 6
              color: "#313244"
            }

            Text {
              id: txt
              x: 8
              width: parent.width - 52
              text: (modelData.appName ? modelData.appName + "\n" : "")
                  + (modelData.summary ? modelData.summary + "\n" : "")
                  + (modelData.body || "")
              color: "#cdd6f4"
              font.pixelSize: 12
              wrapMode: Text.Wrap
            }

            MouseArea {
              x: parent.width - 24
              width: 24
              height: 24
              anchors.verticalCenter: parent.verticalCenter
              onClicked: modelData.dismiss()

              Text {
                anchors.centerIn: parent
                text: "x"
                color: "#f38ba8"
              }
            }
          }
        }
      }
    }
  }
}
