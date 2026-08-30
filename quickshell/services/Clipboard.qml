pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// Clipboard history, watched via `wl-paste --watch` (independent of whether a
// quickshell window owns the clipboard). Each change is printed followed by an
// ASCII record separator (0x1E) so entries survive embedded newlines.
Singleton {
    id: root

    readonly property int maxEntries: 20

    // Array of { text } objects (newest first).
    property var entries: []

    function add(entry: string): void {
        entry = String(entry ?? "").trim();
        if (!entry)
            return;
        const idx = root.entries.findIndex(e => e.text === entry);
        const next = root.entries.slice();
        if (idx >= 0)
            next.splice(idx, 1);
        next.unshift({ text: entry });
        root.entries = next.slice(0, root.maxEntries);
    }

    function copy(entry: string): void {
        copyProc.command = ["sh", "-c", "printf %s \"$1\" | wl-copy --type text", "clipboard-copy", entry];
        copyProc.running = true;
    }

    function clear(): void {
        root.entries = [];
    }

    Process {
        id: watcher
        running: true
        command: ["wl-paste", "--type", "text", "--watch", "sh", "-c", "cat; printf \"\\x1e\""]
        stdout: SplitParser {
            splitMarker: "\x1e"
            onRead: data => root.add(data)
        }
    }

    Process {
        id: copyProc
        running: false
    }
}
