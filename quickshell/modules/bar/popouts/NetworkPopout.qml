import QtQuick
import QtQuick.Layouts
import Quickshell.Networking
import "../../../components"
import "../../../services"

ColumnLayout {
    id: root

    spacing: Tokens.spacing.medium
    implicitWidth: 300
    implicitHeight: col.implicitHeight

    Component.onCompleted: {
        if (Network.wifi)
            Network.wifi.scannerEnabled = true;
    }

    RowLayout {
        StyledText {
            text: "Network"
            font: Tokens.font.titleMedium
            color: Colours.palette.m3onSurface
        }

        Item {
            Layout.fillWidth: true
        }

        StyledRect {
            radius: Tokens.rounding.full
            color: Network.enabled ? Colours.palette.m3primaryContainer : Colours.palette.m3surfaceContainerHighest
            implicitWidth: 56
            implicitHeight: 32

            StyledText {
                anchors.centerIn: parent
                text: Network.enabled ? "On" : "Off"
                color: Network.enabled ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurfaceVariant
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Network.toggle()
            }
        }
    }

    StyledText {
        text: Network.ssid ? ("Connected: " + Network.ssid) : "Not connected"
        color: Colours.palette.m3onSurfaceVariant
        font: Tokens.font.bodyMedium
    }

    Repeater {
        model: Network.wifi ? Network.wifi.networks : null

        delegate: Item {
            required property var modelData

            implicitWidth: 300 - Tokens.padding.large * 2
            implicitHeight: row.implicitHeight

            RowLayout {
                id: row

                anchors.fill: parent
                spacing: Tokens.spacing.medium

                MaterialIcon {
                    text: Icons.getNetworkIcon(Math.round(modelData.signalStrength * 100))
                    color: modelData.connected ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
                }

                StyledText {
                    Layout.fillWidth: true
                    text: modelData.name
                    color: modelData.connected ? Colours.palette.m3onSurface : Colours.palette.m3onSurfaceVariant
                    elide: Text.ElideRight
                }

                StyledText {
                    text: modelData.connected ? "Connected" : ""
                    color: Colours.palette.m3primary
                    font: Tokens.font.bodySmall
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    try {
                        if (modelData.connected)
                            modelData.disconnect();
                        else
                            modelData.connect();
                    } catch (e) {}
                }
            }
        }
    }
}
