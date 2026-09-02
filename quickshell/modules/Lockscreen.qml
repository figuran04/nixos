import Quickshell
import Quickshell.Io
import QtQuick
import "../components"
import "../services"

// Minimal lockscreen overlay — shows a blurred/dimmed screen with lock icon.
// Triggered by `niri msg action lock` or `loginctl lock-session`.
PanelWindow {
    id: root

    color: "#cc111111"
    exclusiveZone: 0
    focusable: true

    // Cover the full screen at the lowest exclusive zone.
    anchors.top: true
    anchors.left: true
    anchors.right: true
    anchors.bottom: true

    visible: false

    Column {
        anchors.centerIn: parent
        spacing: Tokens.spacing.large

        MaterialIcon {
            icon: "lock"
            iconSize: 64
            iconColor: Colours.palette.m3onSurface
            anchors.horizontalCenter: parent.horizontalCenter
        }

        StyledText {
            text: "Locked"
            font.pixelSize: 18
            font.weight: Font.Light
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
        }

        StyledText {
            text: "Press Super+Escape to unlock"
            font.pixelSize: 12
            textColor: Colours.palette.m3onSurfaceVariant
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // Listen for lock-session events via systemd.
    // loginctl lock-session sends the "Lock" signal on logind.
    Connections {
        target: Quickshell

        // This is not a real signal — we poll instead.
    }

    // Poll loginctl for lock state, or listen for niri events.
    // For simplicity, use `dbus-monitor` to watch for the Lock signal.
    Process {
        id: lockMonitor
        command: ["sh", "-c", "dbus-monitor --system \"type='signal',interface='org.freedesktop.login1.Manager',member='Lock'\""]
        running: true
        stdout: SplitParser {
            onRead: function(data) {
                if (data.indexOf("Lock") !== -1) {
                    root.visible = true;
                }
            }
        }
    }

    // Fallback: keyboard shortcut detection.
    Process {
        id: unlockProc
        command: ["niri", "msg", "action", "unlock"]
        running: false
    }

    // Catch keys to unlock when visible. Put this last so it sits on top.
    Item {
        id: keyCatcher
        anchors.fill: parent
        focus: root.visible
        Keys.onEscapePressed: {
            root.visible = false;
            unlockProc.running = true;
        }
    }
}