import Quickshell
import QtQuick
import QtQuick.Layouts
import "./bar" as Bar
import "../components"
import "../services"

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win

            required property var modelData
            screen: modelData

            anchors.top: true
            anchors.right: true
            anchors.bottom: true
            color: "transparent"

            exclusiveZone: dock.width + Tokens.padding.large * 2

            Bar.PopoutState {
                id: popoutState
            }

            RowLayout {
                anchors.fill: parent
                spacing: Tokens.spacing.medium

                Item {
                    Layout.fillWidth: true
                }

                StyledRect {
                    id: dock

                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignRight

                    color: Colours.palette.m3surfaceContainer
                    radius: Tokens.rounding.extraLarge
                    implicitWidth: Tokens.sizes.bar.innerWidth

                    ColumnLayout {
                        id: col

                        anchors.fill: parent
                        anchors.margins: Tokens.padding.medium
                        spacing: Tokens.spacing.medium

                        Bar.Workspaces {}

                        Item {
                            Layout.fillHeight: true
                        }

                        Bar.StatusIcons {
                            popoutState: popoutState
                        }

                        Bar.Tray {}

                        Item {
                            width: Tokens.sizes.bar.innerWidth - Tokens.padding.medium * 2
                            height: width

                            MaterialIcon {
                                anchors.centerIn: parent
                                text: "grid_view"
                                color: Colours.palette.m3secondary
                                fontStyle: Tokens.font.icon
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: parent.opacity = 0.7
                                onExited: parent.opacity = 1
                                onClicked: LauncherState.toggle()
                            }

                            Behavior on opacity {
                                Anim { type: Anim.DefaultEffects }
                            }
                        }

                        Bar.Clock {}

                        Bar.Power {
                            popoutState: popoutState
                        }
                    }
                }
            }

            // The active popout is a separate floating window anchored to the
            // left of the dock (like Caelestia's popout wrapper), so a large
            // popout never inflates the bar or breaks through the screen.
            PopupWindow {
                id: popout

                anchor.window: win

                color: "transparent"
                visible: popoutState.hasCurrent

                implicitWidth: content.implicitWidth
                implicitHeight: content.implicitHeight

                readonly property int sideGap: Tokens.spacing.medium

                anchor.rect.x: win.width - dock.width - width - popout.sideGap
                anchor.rect.y: Math.max(
                    Tokens.padding.medium,
                    Math.min(
                        win.height - height - Tokens.padding.medium,
                        (win.height - height) / 2
                    )
                )

                Bar.Popout {
                    id: content

                    popoutState: popoutState
                    screen: win.screen
                }
            }

            // Transient "now focused" popup shown on window switch.
            Bar.ActiveWindow {
                anchorWindow: win
                panelWidth: win.width
                dockWidth: dock.width
            }
        }
    }
}
