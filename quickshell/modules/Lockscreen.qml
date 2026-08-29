import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Io

WlSessionLock {
  id: lock

  // Lock / unlock from outside the shell, e.g. a Niri keybind:
  //   niri msg action do-nothing   (then call) quickshell ipc call lockscreen lock
  IpcHandler {
    target: "lockscreen"
    function lock() { lock.locked = true }
    function unlock() { lock.locked = false }
  }

  WlSessionLockSurface {
    Rectangle {
      anchors.fill: parent
      color: "#11111b"
    }

    Text {
      anchors.centerIn: parent
      text: "Session locked — click to unlock (demo, no PAM auth)"
      color: "#cdd6f4"
      font.pixelSize: 28
    }

    MouseArea {
      anchors.fill: parent
      onClicked: lock.locked = false
    }
  }
}
