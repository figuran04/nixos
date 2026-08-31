pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Cliphist-based clipboard history.
Singleton {
    id: root

    property var entries: []

    function refresh() {
        listProc.running = true;
    }

    Process {
        id: listProc
        command: ["sh", "-c", "cliphist list 2>/dev/null | head -50"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const raw = this.text;
                const lines = raw === "" ? [] : raw.split("\n");
                const arr = [];
                for (let i = 0; i < lines.length; i += 1) {
                    const line = lines[i];
                    if (line === "") continue;
                    // Format: "<id>\t<contents>"
                    const tab = line.indexOf("\t");
                    let id = "";
                    let content = line;
                    if (tab >= 0) {
                        id = line.slice(0, tab);
                        content = line.slice(tab + 1);
                    }
                    arr.push({ id: id, content: content });
                }
                root.entries = arr;
            }
        }
    }

    Component.onCompleted: root.refresh()
}
