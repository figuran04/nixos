import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.bar as Bar
import qs.components
import qs.services

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

            PopoutState {
                id: popoutState
            }

            RowLayout {
                anchors.fill: parent
                spacing: Tokens.spacing.medium

                Item {
                    Layout.fillWidth: true
                }

                Bar.Popout {
                    popoutState: popoutState
                    screen: win.screen
                    Layout.alignment: Qt.AlignVCenter
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

                        Bar.Clock {}

                        Bar.Power {
                            popoutState: popoutState
                        }
                    }
                }
            }
        }
    }
}
