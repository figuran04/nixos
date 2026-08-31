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

                    delegate: AdaptiveRoundedRect {
                        id: card

                        required property var modelData
                        readonly property int notifIndex: index
                        readonly property int notifCount: server.trackedNotifications.count
                        readonly property bool isFirst: notifIndex === 0
                        readonly property bool isLast: notifIndex === notifCount - 1
                        readonly property bool isSingle: notifCount === 1

                        color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 0.96)
                        implicitWidth: col.width
                        implicitHeight: body.implicitHeight + Tokens.padding.medium * 2

                        tlRadius: (isSingle || isFirst) ? Tokens.rounding.large : 0
                        trRadius: Tokens.rounding.large
                        blRadius: (isSingle || isLast) ? Tokens.rounding.large : 0
                        brRadius: Tokens.rounding.large

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
