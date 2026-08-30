import QtQuick
import QtQuick.Layouts
import "../../../components"
import "../../../services"

ColumnLayout {
    id: root

    spacing: Tokens.spacing.medium
    implicitWidth: 280

    RowLayout {
        StyledText {
            text: "Volume"
            font: Tokens.font.titleMedium
            color: Colours.palette.m3onSurface
        }

        Item {
            Layout.fillWidth: true
        }

        MaterialIcon {
            text: Audio.muted ? "volume_off" : "volume_up"
            color: Colours.palette.m3onSurfaceVariant
        }
    }

    RowLayout {
        MaterialIcon {
            text: "volume_mute"
            color: Colours.palette.m3onSurfaceVariant
        }

        Slider {
            Layout.fillWidth: true
            value: Audio.volume
            from: 0
            to: 1.5
            onMoved: v => Audio.setVolume(v)
        }

        MaterialIcon {
            text: "volume_up"
            color: Colours.palette.m3onSurfaceVariant
        }
    }

    RowLayout {
        StyledText {
            text: Math.round(Audio.volume * 100) + "%"
            color: Colours.palette.m3onSurfaceVariant
        }

        Item {
            Layout.fillWidth: true
        }

        StyledRect {
            radius: Tokens.rounding.full
            color: Audio.muted ? Colours.palette.m3errorContainer : Colours.palette.m3secondaryContainer
            implicitWidth: 88
            implicitHeight: 36

            StyledText {
                anchors.centerIn: parent
                text: Audio.muted ? "Unmute" : "Mute"
                color: Audio.muted ? Colours.palette.m3onErrorContainer : Colours.palette.m3onSecondaryContainer
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Audio.toggleMute()
            }
        }
    }
}
