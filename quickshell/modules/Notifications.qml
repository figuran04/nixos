import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import "../components"
import "../services"

Scope {
    NotificationServer {
        id: server
        onNotification: n => n.tracked = true
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors.top: true
            anchors.right: true
            implicitWidth: 360
            implicitHeight: col.implicitHeight + Tokens.padding.large * 2
            color: "transparent"

            ColumnLayout {
                id: col

                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: Tokens.padding.large
                spacing: Tokens.spacing.medium
                width: parent.width - Tokens.padding.large * 2

                Repeater {
                    model: server.trackedNotifications

                    delegate: StyledRect {
                        required property var modelData

                        radius: Tokens.rounding.large
                        color: Colours.palette.m3surfaceContainerHigh
                        implicitWidth: col.width
                        implicitHeight: body.implicitHeight + Tokens.padding.medium * 2

                        ColumnLayout {
                            id: body

                            anchors.fill: parent
                            anchors.margins: Tokens.padding.medium
                            spacing: Tokens.spacing.extraSmall

                            RowLayout {
                                spacing: Tokens.spacing.small

                                MaterialIcon {
                                    text: "notifications"
                                    color: Colours.palette.m3primary
                                    fontStyle: Tokens.font.iconSmall
                                }

                                StyledText {
                                    Layout.fillWidth: true
                                    text: modelData.appName || "Notification"
                                    font: Tokens.font.labelLarge
                                    color: Colours.palette.m3onSurface
                                    elide: Text.ElideRight
                                }

                                MaterialIcon {
                                    text: "close"
                                    color: Colours.palette.m3onSurfaceVariant
                                    fontStyle: Tokens.font.iconSmall

                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: modelData.dismiss()
                                    }
                                }
                            }

                            StyledText {
                                visible: modelData.summary
                                text: modelData.summary || ""
                                font: Tokens.font.bodyLarge
                                color: Colours.palette.m3onSurface
                                elide: Text.ElideRight
                            }

                            StyledText {
                                visible: modelData.body
                                text: modelData.body || ""
                                font: Tokens.font.bodyMedium
                                color: Colours.palette.m3onSurfaceVariant
                                wrapMode: Text.Wrap
                            }
                        }
                    }
                }
            }
        }
    }
}
