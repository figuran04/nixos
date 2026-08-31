import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../services"

// Media control popout.
ColumnLayout {
    id: root

    spacing: Tokens.spacing.standard
    anchors.fill: parent

    StyledText {
        text: "Media"
        font.pixelSize: 14
        fontWeight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        Layout.fillWidth: true
    }

    MaterialIcon {
        icon: Media.playing ? "pause" : "play_arrow"
        iconSize: 48
        iconColor: Colours.palette.m3primary
        Layout.alignment: Qt.AlignHCenter
    }

    StyledText {
        text: Media.player ? (Media.player.trackTitle || "No title") : "Nothing playing"
        font.pixelSize: 12
        horizontalAlignment: Text.AlignHCenter
        Layout.fillWidth: true
        elide: Text.ElideRight
    }

    StyledText {
        text: Media.player ? (Media.player.trackArtist || "") : ""
        font.pixelSize: 10
        textColor: Colours.palette.m3onSurfaceVariant
        horizontalAlignment: Text.AlignHCenter
        Layout.fillWidth: true
        elide: Text.ElideRight
    }
}
