import QtQuick
import QtQuick.Layouts
import "../../../components"
import "../../../services"

ColumnLayout {
    id: root

    spacing: Tokens.spacing.medium
    implicitWidth: 300

    // ---- System section ----
    ColumnLayout {
        spacing: Tokens.spacing.small

        RowLayout {
            StyledText {
                text: "System"
                font: Tokens.font.titleMedium
                color: Colours.palette.m3onSurface
            }
            Item { Layout.fillWidth: true }
            StyledText {
                text: Math.round(SysInfo.cpu * 100) + "% CPU"
                font: Tokens.font.bodySmall
                color: Colours.palette.m3onSurfaceVariant
            }
        }

        MetricBar {
            label: "CPU"
            value: SysInfo.cpu
            caption: Math.round(SysInfo.cpu * 100) + "%"
        }

        MetricBar {
            label: "RAM"
            value: SysInfo.memFrac
            caption: root.bytes(SysInfo.memUsed) + " / " + root.bytes(SysInfo.memTotal)
        }

        MetricBar {
            label: "Disk"
            value: SysInfo.diskFrac
            caption: root.bytes(SysInfo.diskUsed) + " / " + root.bytes(SysInfo.diskTotal)
        }
    }

    // ---- Media section ----
    ColumnLayout {
        spacing: Tokens.spacing.small

        RowLayout {
            StyledText {
                text: "Media"
                font: Tokens.font.titleMedium
                color: Colours.palette.m3onSurface
            }
            Item { Layout.fillWidth: true }
            StyledText {
                text: Media.player ? Media.player.identity : "no player"
                font: Tokens.font.bodySmall
                color: Colours.palette.m3onSurfaceVariant
            }
        }

        ColumnLayout {
            visible: Media.player != null
            spacing: Tokens.spacing.extraSmall

            StyledText {
                text: Media.player.trackTitle || "Unknown Title"
                font: Tokens.font.bodyMedium
                color: Colours.palette.m3onSurface
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
            StyledText {
                text: Media.player.trackArtist || "Unknown Artist"
                font: Tokens.font.bodySmall
                color: Colours.palette.m3onSurfaceVariant
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: Tokens.spacing.medium
                Layout.alignment: Qt.AlignHCenter

                ControlButton { icon: "skip_previous"; enabled: Media.player?.canGoPrevious ?? false; onClicked: Media.player.previous() }
                ControlButton { icon: Media.player?.isPlaying ? "pause" : "play_arrow"; enabled: Media.player?.canTogglePlaying ?? false; onClicked: Media.player.togglePlaying() }
                ControlButton { icon: "skip_next"; enabled: Media.player?.canGoNext ?? false; onClicked: Media.player.next() }
            }
        }
    }

    function bytes(n: real): string {
        if (isNaN(n) || n <= 0) return "0 B";
        const units = ["B", "KB", "MB", "GB", "TB"];
        let i = 0;
        while (n >= 1024 && i < units.length - 1) { n /= 1024; i++; }
        return n.toFixed(i === 0 ? 0 : 1) + " " + units[i];
    }

    component MetricBar: ColumnLayout {
        property string label: ""
        property real value: 0
        property string caption: ""

        spacing: Tokens.spacing.extraSmall

        RowLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.small

            StyledText {
                text: parent.parent.parent.label
                font: Tokens.font.bodySmall
                color: Colours.palette.m3onSurfaceVariant
            }
            Item { Layout.fillWidth: true }
            StyledText {
                text: parent.parent.parent.caption
                font: Tokens.font.bodySmall
                color: Colours.palette.m3onSurfaceVariant
            }
        }

        StyledRect {
            Layout.fillWidth: true
            height: 6
            radius: Tokens.rounding.full
            color: Colours.palette.m3surfaceContainerHigh

            StyledRect {
                height: parent.height
                width: parent.width * Math.max(0, Math.min(1, parent.parent.parent.value))
                radius: Tokens.rounding.full
                color: Colours.palette.m3primary

                Behavior on width {
                    Anim { type: Anim.DefaultEffects }
                }
            }
        }
    }

    component ControlButton: Item {
        property string icon: ""
        property bool enabled: false
        property var onClicked: null

        implicitWidth: 40
        implicitHeight: 40

        opacity: enabled ? 1 : 0.4

        StyledRect {
            anchors.fill: parent
            radius: Tokens.rounding.full
            color: "transparent"
        }

        MaterialIcon {
            anchors.centerIn: parent
            text: parent.icon
            color: Colours.palette.m3onSurface
        }

        MouseArea {
            anchors.fill: parent
            enabled: parent.enabled
            hoverEnabled: true
            cursorShape: parent.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: parent.onClicked()
        }
    }
}
