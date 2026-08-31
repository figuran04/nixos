pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string hostname: "hp"
    property string cpuLoad: "0%"
    property string memUsed: "0"

    Process {
        id: hostProc
        command: ["hostname"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.hostname = this.text.trim()
        }
    }

    Process {
        id: loadProc
        command: ["sh", "-c", "cat /proc/loadavg | cut -d' ' -f1-3"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.cpuLoad = this.text.trim()
        }
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free -h | awk '/Mem:/{print $3}'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.memUsed = this.text.trim()
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            loadProc.running = true;
            memProc.running = true;
        }
    }
}
