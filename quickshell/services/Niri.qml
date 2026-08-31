pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// Minimal Niri integration via the `niri msg` CLI for workspaces.
Singleton {
    id: root

    // Flat list of workspaces across all outputs. Each entry is a plain JS
    // object: {id, idx, name, output, isActive, isUrgent}. Reassigning this
    // array (instead of mutating it) lets QML bindings that read it re-run.
    property var workspaces: []

    function refresh() {
        procWorkspaces.running = true;
    }

    function focusWorkspace(id) {
        focusProc.command = ["niri", "msg", "action", "focus-workspace", String(id)];
        focusProc.running = true;
    }

    Process {
        id: procWorkspaces
        command: ["niri", "msg", "-j", "workspaces"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const raw = this.text.trim();
                if (raw === "") return;
                try {
                    // `niri msg -j workspaces` returns a flat JSON array of
                    // workspace objects, each with output/is_active/is_urgent/...
                    const data = JSON.parse(raw);
                    const list = [];
                    if (Array.isArray(data)) {
                        for (const ws of data) {
                            list.push({
                                id: ws.id,
                                idx: ws.idx,
                                name: ws.name !== undefined ? ws.name : String(ws.idx),
                                output: ws.output,
                                isActive: !!ws.is_active,
                                isUrgent: !!ws.is_urgent
                            });
                        }
                    }
                    root.workspaces = list;
                } catch (e) {
                    console.log("niri msg workspaces parse error:", e);
                }
            }
        }
    }

    Process {
        id: focusProc
        command: []
        running: false
    }

    // Re-poll regularly to stay in sync and after focus changes.
    Timer {
        interval: 1500
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: root.refresh()
}
