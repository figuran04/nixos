import QtQuick
import QtQuick.Layouts
import "../../../components"
import "../../../services"

ColumnLayout {
    id: root

    spacing: Tokens.spacing.medium
    implicitWidth: 300

    RowLayout {
        StyledText {
            text: "Bluetooth"
            font: Tokens.font.titleMedium
            color: Colours.palette.m3onSurface
        }

        Item {
            Layout.fillWidth: true
        }

        StyledRect {
            radius: Tokens.rounding.full
            color: Bluetooth.enabled ? Colours.palette.m3primaryContainer : Colours.palette.m3surfaceContainerHighest
            implicitWidth: 56
            implicitHeight: 32

            StyledText {
                anchors.centerIn: parent
                text: Bluetooth.enabled ? "On" : "Off"
                color: Bluetooth.enabled ? Colours.palette.m3onPrimaryContainer : Colours.palette.m3onSurfaceVariant
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (Bluetooth.defaultAdapter)
                        Bluetooth.defaultAdapter.powered = !Bluetooth.defaultAdapter.powered;
                }
            }
        }
    }

    StyledText {
        text: Bluetooth.connected > 0 ? (Bluetooth.connected + " device(s) connected") : "No devices connected"
        color: Colours.palette.m3onSurfaceVariant
        font: Tokens.font.bodyMedium
    }

    Repeater {
        model: Bluetooth.devices

        delegate: Item {
            required property var modelData

            implicitWidth: 300 - Tokens.padding.large * 2
            implicitHeight: row.implicitHeight

            RowLayout {
                id: row

                anchors.fill: parent
                spacing: Tokens.spacing.medium

                MaterialIcon {
                    text: modelData.connected ? "bluetooth_connected" : "bluetooth"
                    color: modelData.connected ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
                }

                StyledText {
                    Layout.fillWidth: true
                    text: modelData.name
                    color: modelData.connected ? Colours.palette.m3onSurface : Colours.palette.m3onSurfaceVariant
                    elide: Text.ElideRight
                }

                StyledText {
                    text: modelData.connected ? "On" : "Off"
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
