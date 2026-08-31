import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../services"

// Network status popout.
ColumnLayout {
    id: root

    spacing: Tokens.spacing.standard
    anchors.fill: parent

    StyledText {
        text: "Network"
        font.pixelSize: 14
        fontWeight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        Layout.fillWidth: true
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Tokens.spacing.medium

        MaterialIcon {
            icon: Icons.getNetworkIcon(Network.enabled, Network.connected, Network.signal / 100)
            iconSize: Tokens.sizes.popout.iconSize
            iconColor: Colours.palette.m3primary
        }

        ColumnLayout {
            spacing: Tokens.spacing.nano
            Layout.fillWidth: true

            StyledText {
                text: Network.connected ? Network.ssid || "Connected" : (Network.enabled ? "Scanning..." : "Wi-Fi off")
                font.pixelSize: 13
            }

            StyledText {
                text: Network.connected ? "Signal: " + Math.round(Network.signal) + "%" : (Network.enabled ? "No connection" : "Disabled")
                font.pixelSize: 10
                textColor: Colours.palette.m3onSurfaceVariant
            }
        }
    }
}
