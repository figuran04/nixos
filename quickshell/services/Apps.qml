pragma Singleton
import Quickshell
import QtQuick

// Plugin-free application index for the launcher, backed by the
// built-in `Quickshell.DesktopEntries` desktop-entry parser.
Singleton {
    id: root

    // Searchable model rows: { name, icon, comment, keywords, entry }.
    property ListModel entries: ListModel {}

    // Rebuild the searchable model from the desktop-entry index.
    function refresh(): void {
        root.entries.clear();
        const apps = DesktopEntries.applications;
        for (let i = 0; i < apps.count; i++) {
            const app = apps.get(i);
            if (!app || !app.name)
                continue;
            root.entries.append({
                name: app.name,
                icon: app.icon,
                comment: app.comment || app.genericName || "",
                keywords: (app.keywords || []).join(" "),
                entry: app
            });
        }
    }

    // Returns array of matching row indices, ranked by name-first prefix.
    function search(text: string): var {
        const q = text.trim().toLowerCase();
        if (q === "")
            return root.range(0, root.entries.count);

        const out = [];
        for (let i = 0; i < root.entries.count; i++) {
            const row = root.entries.get(i);
            const name = (row.name || "").toLowerCase();
            const hay = (name + " " + (row.keywords || "").toLowerCase() + " " + (row.comment || "").toLowerCase());
            if (name.startsWith(q))
                out.unshift(i);       // prefix matches rank first
            else if (name.includes(q) || hay.includes(q))
                out.push(i);
        }
        return out;
    }

    function launch(rowIndex: int): void {
        const row = root.entries.get(rowIndex);
        if (row && row.entry)
            row.entry.execute();
    }

    function range(start: int, end: int): var {
        const out = [];
        for (let i = start; i < end; i++)
            out.push(i);
        return out;
    }

    Component.onCompleted: root.refresh()
}
