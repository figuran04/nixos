import Quickshell
import QtQuick
import QtQuick.Layouts
import "./bar" as Bar
import "../components"
import "../services"

// Per-screen dock bar attached to the right edge, Noctalia style.
Scope {
    id: barRoot

    // Shared popout open/close state for all screens.
    Bar.PopoutState {
        id: popoutState
    }

    // The dock windows (one per screen).
    Variants {
        id: dockVariants
        model: Quickshell.screens

        delegate: Component {
            PanelWindow {
                id: win

                required property var modelData
                screen: modelData

                anchors.top: true
                anchors.right: true
                anchors.bottom: true
                color: "transparent"

                readonly property bool popoutOpen: popoutState.hasCurrent

                // Reserve horizontal space on the right so windows avoid the dock.
                exclusiveZone: dockWrapper.width

                RowLayout {
                    anchors.fill: parent
                    spacing: 0

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
                            tlRadius: win.popoutOpen ? 0 : Tokens.rounding.extraLarge
                            trRadius: Tokens.rounding.extraLarge
                            blRadius: win.popoutOpen ? 0 : Tokens.rounding.extraLarge
                            brRadius: Tokens.rounding.extraLarge
                            tlConcave: win.popoutOpen ? Tokens.rounding.medium : 0
                            blConcave: win.popoutOpen ? Tokens.rounding.medium : 0

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Tokens.padding.medium
                                spacing: Tokens.spacing.medium

                                Bar.Workspaces {
                                    screenName: win.screen ? win.screen.name : ""
                                }

                                Item {
                                    Layout.fillHeight: true
                                }

                                Bar.Clock {}

                                Item {
                                    Layout.fillHeight: true
                                }

                                Bar.StatusIcons {
                                    store: popoutState
                                }

                                Item {
                                    Layout.fillHeight: true
                                }

                                Bar.Power {
                                    store: popoutState
                                    onOpenPower: popoutState.request("power", "left")
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // The popout panels (one per screen, floating left of the dock).
    Variants {
        model: Quickshell.screens

        delegate: Component {
            Bar.Popout {
                required property var modelData
                screen: modelData
                store: popoutState
            }
        }
    }
}