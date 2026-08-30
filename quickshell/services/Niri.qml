pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// Central niri state (windows + workspaces), driven by a single event-stream
// process so every widget (workspaces, active-window, dashboard, ...) reads
// the same live data instead of each opening its own `niri msg` stream.
Singleton {
    id: root

    property var workspaces: []
    property var windows: []

    readonly property var focusedWorkspaceId: root.workspaces.find(w => w.is_active === true)?.id ?? ""
    readonly property var focusedWorkspaceIndex: root.workspaces.findIndex(w => w.is_active === true)
    readonly property var focusedWindow: root.windows.find(w => w.is_focused === true) ?? null
    readonly property var focusedWindowId: focusedWindow?.id ?? ""

    function applyWorkspaces(list: var): void {
        root.workspaces = Array.isArray(list) ? list : (list?.workspaces ?? []);
    }

    function setActiveWorkspace(id: string): void {
        root.workspaces = root.workspaces.map(w => Object.assign({}, w, { is_active: w.id === id }));
    }

    function applyWindows(list: var): void {
        root.windows = Array.isArray(list) ? list.slice() : (list?.windows?.slice() ?? []);
    }

    function upsertWindow(w: var): void {
        if (!w || w.id === undefined)
            return;
        const idx = root.windows.findIndex(x => x.id === w.id);
        const next = root.windows.slice();
        if (idx >= 0)
            next[idx] = Object.assign({}, next[idx], w);
        else
            next.push(Object.assign({ layout: {} }, w));
        root.windows = next;
    }

    function removeWindow(id: var): void {
        const idx = root.windows.findIndex(x => x.id === id);
        if (idx >= 0) {
            const next = root.windows.slice();
            next.splice(idx, 1);
            root.windows = next;
        }
    }

    function windowsOn(wsId: var): var {
        return root.windows.filter(w => w.workspace_id !== null && w.workspace_id !== undefined && String(w.workspace_id) === String(wsId));
    }

    function focusWindow(id: var): void {
        focusProc.command = ["niri", "msg", "action", "focus-window", "--id", String(id)];
        focusProc.running = true;
    }

    function focusWorkspace(idx: int): void {
        focusProc.command = ["niri", "msg", "action", "focus-workspace", "--workspace", String(idx + 1)];
        focusProc.running = true;
    }

    // Initial load (niri returns the array directly here).
    Process {
        id: initialWs
        running: true
        command: ["niri", "msg", "-j", "workspaces"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.applyWorkspaces(JSON.parse(text));
                } catch (e) {}
            }
        }
    }

    Process {
        id: initialWindows
        running: true
        command: ["niri", "msg", "-j", "windows"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.applyWindows(JSON.parse(text)?.windows);
                } catch (e) {}
            }
        }
    }

    // Live updates via the niri event stream (no polling).
    Process {
        id: eventStream
        running: true
        command: ["niri", "msg", "-j", "event-stream"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    const e = JSON.parse(data);
                    if (e?.WorkspacesChanged)
                        root.applyWorkspaces(e.WorkspacesChanged);
                    else if (e?.WorkspaceActivated)
                        root.setActiveWorkspace(e.WorkspaceActivated.id);
                    else if (e?.WindowsChanged)
                        root.applyWindows(e.WindowsChanged.windows ?? []);
                    else if (e?.WindowClosed)
                        root.removeWindow(e.WindowClosed.id);
                    else if (e?.WindowOpenedOrChanged)
                        root.upsertWindow(e.WindowOpenedOrChanged.window);
                    else if (e?.WindowFocusChanged !== undefined)
                        root.applyWindows(root.windows.map(w => Object.assign({}, w, { is_focused: w.id === e.WindowFocusChanged?.id })));
                } catch (e) {}
            }
        }
    }

    Process {
        id: focusProc
        running: false
    }
}
