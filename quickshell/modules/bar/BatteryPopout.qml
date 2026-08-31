import QtQuick
import QtQuick.Layouts
import "../components"
import "../services"

// Battery status popout.
ColumnLayout {
    id: root

    spacing: Tokens.spacing.standard
    anchors.fill: parent

    StyledText {
        text: "Battery"
        font.pixelSize: 14
        fontWeight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        Layout.fillWidth: true
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Tokens.spacing.medium

        MaterialIcon {
            icon: Icons.getBatteryIcon(Battery.percentage, Battery.charging)
            iconSize: Tokens.sizes.popout.iconSize
            iconColor: Battery.charging ? Colours.palette.m3primary : Colours.palette.m3onSurfaceVariant
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.nano

            StyledText {
                text: Math.round(Battery.percentage) + "%"
                font.pixelSize: 16
                fontWeight: Font.Bold
            }

            StyledText {
                text: Battery.charging ? "Charging" : (Battery.onBattery ? "On battery" : "On AC")
                font.pixelSize: 10
                textColor: Colours.palette.m3onSurfaceVariant
            }
        }
    }
}
