import Quickshell
import QtQuick
import QtQuick.Layouts
import "../components"
import "../services"

// Volume / brightness on-screen display.
PanelWindow {
    id: root

    anchors.bottom: true
    anchors.left: true

    color: "transparent"
    exclusiveZone: 0

    implicitWidth: 360
    implicitHeight: 70

    readonly property int volume: Math.round(Audio.volume * 100)
    property bool show: false

    visible: show

    Item {
        id: fade
        anchors.fill: parent
        opacity: root.show ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: Tokens.anim.durations.fast }
        }

        AdaptiveRoundedRect {
            anchors.fill: parent
            anchors.margins: Tokens.padding.large
            color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 0.96)
            borderColor: Colours.withAlpha(Colours.palette.m3outline, 0.35)
            borderWidth: 1
            tlRadius: Tokens.rounding.large
            trRadius: Tokens.rounding.large
            blRadius: Tokens.rounding.large
            brRadius: Tokens.rounding.large

            RowLayout {
                anchors.fill: parent
                anchors.margins: Tokens.padding.medium
                spacing: Tokens.spacing.medium

                MaterialIcon {
                    icon: Icons.getVolumeIcon(Audio.volume, Audio.muted)
                    iconSize: Tokens.sizes.popout.iconSize
                    iconColor: Colours.palette.m3primary
                }

                Slider {
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: root.volume
                }

                StyledText {
                    text: root.volume + "%"
                    font.pixelSize: 12
                    textColor: Colours.palette.m3onSurfaceVariant
                }
            }
        }
    }

    // Show briefly whenever volume changes.
    onVolumeChanged: {
        root.show = true;
        hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: 2000
        onTriggered: root.show = false
    }
}