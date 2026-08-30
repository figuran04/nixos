import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../components"
import "../../services"

StyledRect {
    id: root

    color: Colours.palette.m3surfaceContainer
    radius: Tokens.rounding.full
    implicitWidth: col.implicitWidth + Tokens.padding.medium * 2
    implicitHeight: col.implicitHeight + Tokens.padding.medium * 2

    property var workspaces: []
    property var windows: []

    readonly property int entry: Tokens.sizes.bar.innerWidth - Tokens.padding.medium * 2

    function applyWorkspaces(list: var): void {
        root.workspaces = Array.isArray(list) ? list : (list?.workspaces ?? []);
    }

    function setActive(id: string): void {
        let changed = false;
        const next = root.workspaces.map(w => {
            const active = w.id === id;
            if (w.is_active !== active)
                changed = true;
            return Object.assign({}, w, { is_active: active });
        });
        if (changed)
            root.workspaces = next;
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
    }

    ColumnLayout {
        id: col

        anchors.fill: parent
        anchors.margins: Tokens.padding.medium
        spacing: Tokens.spacing.small

        Repeater {
            model: root.workspaces

            ColumnLayout {
                id: ws

                required property var modelData

                Layout.alignment: Qt.AlignHCenter
                spacing: Tokens.spacing.extraSmall

                // Workspace pill: click to focus the workspace.
                Rectangle {
                    id: pill
                    Layout.alignment: Qt.AlignHCenter
                    width: root.entry
                    height: root.entry
                    radius: Tokens.rounding.full
                    color: modelData.is_active ? Colours.palette.m3primary : "transparent"
                    border.color: modelData.is_active ? "transparent" : Colours.palette.m3outlineVariant
                    border.width: 1

                    StyledText {
                        anchors.centerIn: parent
                        text: String(modelData.idx + 1)
                        font: Tokens.font.bodyMedium
                        color: modelData.is_active ? Colours.palette.m3onPrimary : Colours.palette.m3onSurfaceVariant
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.focusProc.command = ["niri", "msg", "action", "focus-workspace", "--workspace", String(modelData.idx + 1)]
                    }
                }

                // App icons for windows on this workspace.
                Repeater {
                    model: root.windowsOn(modelData.id)

                    Rectangle {
                        id: icon
                        required property var modelData

                        Layout.alignment: Qt.AlignHCenter
                        width: root.entry
                        height: root.entry
                        radius: Tokens.rounding.full
                        color: modelData.id === root.focusedWindowId ? Colours.palette.m3secondaryContainer : "transparent"
                        border.color: "transparent"
                        border.width: 0

                        Image {
                            anchors.centerIn: parent
                            width: 18
                            height: 18
                            source: Icons.getAppIcon(modelData.app_id ?? "", "")
                            sourceSize.width: 18
                            sourceSize.height: 18
                            fillMode: Image.PreserveAspectFit
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.focusWindow(modelData.id)
                        }
                    }
                }
            }
        }
    }

    readonly property var focusedWindowId: root.windows.find(w => w.is_focused === true)?.id ?? ""

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
                    if (e.WorkspacesChanged)
                        root.applyWorkspaces(e.WorkspacesChanged);
                    else if (e.WorkspaceActivated)
                        root.setActive(e.WorkspaceActivated.id);
                    else if (e.WindowsChanged)
                        root.applyWindows(e.WindowsChanged.windows);
                    else if (e.WindowClosed)
                        root.removeWindow(e.WindowClosed.id);
                    else if (e.WindowOpenedOrChanged)
                        root.upsertWindow(e.WindowOpenedOrChanged.window);
                } catch (e) {}
            }
        }
    }

    Process {
        id: focusProc
        running: false
    }
}
