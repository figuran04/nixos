// shell.qml — Quickshell: bar atas minimalis untuk Niri.
// Dimuat dari ~/.config/quickshell/shell.qml (lihat home/quickshell.nix).
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    // Status workspace niri, diperbarui lewat polling `niri msg`.
    property var workspaces: []

    readonly property var sortedWorkspaces: {
        const list = [...workspaces];
        list.sort((a, b) => a.idx - b.idx);
        return list;
    }

    Process {
        id: workspaceProc
        command: ["niri", "msg", "--json", "workspaces"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.workspaces = JSON.parse(this.text);
                } catch (e) {
                    console.warn("quickshell: gagal parse workspace niri:", e);
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: workspaceProc.running = true
        Component.onCompleted: workspaceProc.running = true
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 32
            color: "#1e1e2e"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 10

                // --- Workspaces niri ---
                Row {
                    spacing: 6

                    Repeater {
                        model: root.sortedWorkspaces

                        Rectangle {
                            required property var modelData

                            width: 10
                            height: 10
                            radius: 5
                            color: modelData.is_focused ? "#89b4fa"
                                 : modelData.is_active ? "#7f849c"
                                 : "#45475a"

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Quickshell.execDetached([
                                    "niri", "msg", "action",
                                    "focus-workspace", String(modelData.idx)
                                ])
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // --- Jam (tengah) ---
                Text {
                    text: Qt.formatDateTime(clock.date, "ddd dd MMM  HH:mm")
                    color: "#cdd6f4"
                    font.family: "Geist Mono"
                    font.pixelSize: 13
                }

                Item { Layout.fillWidth: true }

                // --- System tray (kanan) ---
                Row {
                    spacing: 8

                    Repeater {
                        model: SystemTray.items

                        Item {
                            required property var modelData

                            implicitWidth: 18
                            implicitHeight: 18

                            Image {
                                anchors.fill: parent
                                source: modelData.icon
                                sourceSize.width: 18
                                sourceSize.height: 18
                            }

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.LeftButton | Qt.MiddleButton
                                onClicked: (mouse) => {
                                    if (mouse.button === Qt.LeftButton)
                                        modelData.activate();
                                    else if (mouse.button === Qt.MiddleButton)
                                        modelData.secondaryActivate();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
