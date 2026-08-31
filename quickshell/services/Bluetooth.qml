pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Bluetooth status via bluetoothctl.
Singleton {
    id: root

    property bool enabled: false

    function refresh() {
        btProc.running = true;
    }

    Process {
        id: btProc
        command: ["sh", "-c", "bluetoothctl show 2>/dev/null | grep -q 'Powered: yes' && echo yes || echo no"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.enabled = this.text.trim() === "yes"
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: root.refresh()
}
