import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "../../components"
import "../../services"

StyledRect {
    id: root

    color: Colours.palette.m3surfaceContainer
    radius: Tokens.rounding.full
    implicitWidth: Tokens.sizes.bar.innerWidth
    implicitHeight: col.implicitHeight + Tokens.padding.medium * 2

    property var workspaces: []

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

    ColumnLayout {
        id: col

        anchors.fill: parent
        anchors.margins: Tokens.padding.medium
        spacing: Tokens.spacing.medium

        Repeater {
            model: root.workspaces

            Rectangle {
                id: ws

                required property var modelData

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
                    onClicked: focusProc.command = ["niri", "msg", "action", "focus-workspace", "--workspace", String(modelData.idx + 1)]
                }
            }
        }
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
                } catch (e) {}
            }
        }
    }

    Process {
        id: focusProc
        running: false
    }
}
