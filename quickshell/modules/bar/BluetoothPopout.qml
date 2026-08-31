import QtQuick
import QtQuick.Layouts
import "../components"
import "../services"

// Bluetooth status popout.
ColumnLayout {
    id: root

    spacing: Tokens.spacing.standard
    anchors.fill: parent

    StyledText {
        text: "Bluetooth"
        font.pixelSize: 14
        fontWeight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        Layout.fillWidth: true
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Tokens.spacing.medium

        MaterialIcon {
            icon: Bluetooth.enabled ? "bluetooth" : "bluetooth_disabled"
            iconSize: Tokens.sizes.popout.iconSize
            iconColor: Bluetooth.enabled ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
        }

        StyledText {
            text: Bluetooth.enabled ? "Bluetooth on" : "Bluetooth off"
            font.pixelSize: 13
            Layout.fillWidth: true
        }
    }
}
