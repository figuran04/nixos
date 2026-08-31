import Quickshell
import QtQuick
import QtQuick.Layouts
import "../components"
import "../services"

Scope {
    id: root

    property QtObject ctrl: QtObject {
        id: ctrl

        property real volume: Audio.volume
        property bool muted: Audio.muted
        property real offsetScale: 1
        property bool hovered: false

        function show() {
            ctrl.offsetScale = 0;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 1500
        onTriggered: {
            if (!ctrl.hovered)
                ctrl.offsetScale = 1;
        }
    }

    Connections {
        target: Audio

        function onVolumeChanged() {
            ctrl.show();
        }
        function onMutedChanged() {
            ctrl.show();
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win

            required property var modelData
            screen: modelData

            anchors.right: true
            anchors.top: true

            color: "transparent"
            visible: ctrl.offsetScale < 1

            implicitWidth: content.implicitWidth + Tokens.padding.large * 2
            implicitHeight: content.implicitHeight + Tokens.padding.medium * 2

            readonly property int shownGap: Tokens.sizes.bar.outerWidth + 12

            margins.top: (modelData.height - win.implicitHeight) / 2
            margins.right: win.shownGap + 60 * ctrl.offsetScale

            Behavior on margins.right {
                Anim { type: Anim.Emphasized }
            }

            AdaptiveRoundedRect {
                id: content

                anchors.fill: parent

                color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 0.96)
                tlRadius: Tokens.rounding.extraLarge
                trRadius: 0
                blRadius: Tokens.rounding.extraLarge
                brRadius: 0

                opacity: 1 - ctrl.offsetScale
                Behavior on opacity {
                    Anim { type: Anim.DefaultEffects }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: ctrl.hovered = true
                    onExited: {
                        ctrl.hovered = false;
                        hideTimer.restart();
                    }

                    onWheel: wheel => {
                        if (wheel.angleDelta.y > 0)
                            Audio.incrementVolume();
                        else if (wheel.angleDelta.y < 0)
                            Audio.decrementVolume();
                        ctrl.show();
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Tokens.padding.medium
                    spacing: Tokens.spacing.large

                    MaterialIcon {
                        Layout.alignment: Qt.AlignVCenter
                        text: Icons.getVolumeIcon(ctrl.volume, ctrl.muted)
                        color: Colours.palette.m3onSurface
                        fontStyle: Tokens.font.iconMedium

                        MouseArea {
                            anchors.fill: parent
                            onPressed: Audio.toggleMute()
                        }
                    }

                    Slider {
                        id: slider

                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter

                        value: ctrl.volume
                        to: 1.5

                        onMoved: v => Audio.setVolume(v)
                    }
                }
            }
        }
    }
}
