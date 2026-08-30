import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import "../../../components"
import "../../../services"

ColumnLayout {
    id: root

    spacing: Tokens.spacing.medium
    implicitWidth: 300

    readonly property var player: Media.player

    StyledText {
        text: "Now Playing"
        font: Tokens.font.titleMedium
        color: Colours.palette.m3onSurface
    }

    StyledText {
        text: player != null ? (player.title || "Unknown title") : "Nothing playing"
        font: Tokens.font.titleLarge
        color: Colours.palette.m3onSurface
        elide: Text.ElideRight
        Layout.fillWidth: true
    }

    StyledText {
        text: player != null ? (player.artist || "") : ""
        color: Colours.palette.m3onSurfaceVariant
        elide: Text.ElideRight
        Layout.fillWidth: true
    }

    RowLayout {
        spacing: Tokens.spacing.large
        Layout.alignment: Qt.AlignHCenter

        MaterialIcon {
            text: "skip_previous"
            color: Colours.palette.m3onSurface
            fontStyle: Tokens.font.iconMedium
            MouseArea {
                anchors.fill: parent
                onClicked: if (player) player.previous()
            }
        }

        MaterialIcon {
            text: (player != null && player.playbackState === MprisPlaybackState.Playing) ? "pause" : "play_arrow"
            color: Colours.palette.m3onSurface
            fontStyle: Tokens.font.iconLarge
            MouseArea {
                anchors.fill: parent
                onClicked: if (player) {
                    if (player.playbackState === MprisPlaybackState.Playing)
                        player.pause();
                    else
                        player.play();
                }
            }
        }

        MaterialIcon {
            text: "skip_next"
            color: Colours.palette.m3onSurface
            fontStyle: Tokens.font.iconMedium
            MouseArea {
                anchors.fill: parent
                onClicked: if (player) player.next()
            }
        }
    }
}
