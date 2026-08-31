pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Network status via nmcli.
Singleton {
    id: root

    property bool enabled: false
    property bool connected: false
    property string ssid: ""
    property real signal: 0

    function refresh() {
        netProc.running = true;
    }

    Process {
        id: netProc
        command: ["nmcli", "-t", "-f", "GENERAL.STATE", "device", "show", "wlan0"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const out = this.text.trim();
                root.enabled = out !== "";
                root.connected = out.indexOf("connected") !== -1;
            }
        }
    }

    Process {
        id: wifiProc
        command: ["nmcli", "-t", "-f", "SSID,SIGNAL", "device", "wifi", "list", "--rescan", "no"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const line = this.text.split("\n")[0];
                if (line !== "") {
                    const parts = line.split(":");
                    root.ssid = parts[0];
                    root.signal = parts.length > 1 ? Number(parts[1]) : 0;
                } else {
                    root.ssid = "";
                }
            }
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
