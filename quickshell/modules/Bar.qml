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

            exclusiveZone: dockWrapper.width

            Bar.PopoutState {
                id: popoutState
            }

            readonly property bool popoutOpen: popoutState.hasCurrent

            RowLayout {
                anchors.fill: parent
                spacing: Tokens.spacing.medium

                Item {
                    Layout.fillWidth: true
                }

                Item {
                    id: dockWrapper
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignRight
                    implicitWidth: Tokens.sizes.bar.innerWidth + Tokens.padding.large * 2

                    AdaptiveRoundedRect {
                        id: dock

                        anchors.fill: parent
                        anchors.margins: Tokens.padding.large

                        color: Colours.palette.m3surfaceContainer
                        borderColor: Colours.withAlpha(Colours.palette.m3outline, 0.35)
                        borderWidth: 1
                        tlRadius: Tokens.rounding.extraLarge
                        trRadius: Tokens.rounding.extraLarge
                        blRadius: Tokens.rounding.extraLarge
                        brRadius: Tokens.rounding.extraLarge
                        tlConcave: win.popoutOpen ? Tokens.rounding.medium : 0
                        blConcave: win.popoutOpen ? Tokens.rounding.medium : 0

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
            }

            PopupWindow {
                id: popout

                anchor.window: win

                color: "transparent"
                visible: popoutState.hasCurrent

                implicitWidth: content.implicitWidth
                implicitHeight: content.implicitHeight

                readonly property int sideGap: Tokens.spacing.medium

                anchor.rect.x: win.width - dockWrapper.width - width - popout.sideGap
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

            Bar.ActiveWindow {
                anchorWindow: win
                panelWidth: win.width
                dockWidth: dockWrapper.width
            }
        }
    }
}
