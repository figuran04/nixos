import QtQuick
import QtQuick.Layouts
import "../../../components"
import "../../../services"

ColumnLayout {
    id: root

    spacing: Tokens.spacing.medium
    implicitWidth: 240
    implicitHeight: col.implicitHeight

    RowLayout {
        StyledText {
            text: "Battery"
            font: Tokens.font.titleMedium
            color: Colours.palette.m3onSurface
        }

        Item {
            Layout.fillWidth: true
        }

        MaterialIcon {
            text: Icons.getBatteryIcon(Battery.percentage, Battery.charging)
            color: Colours.palette.m3onSurfaceVariant
        }
    }

    StyledText {
        text: Math.round(Battery.percentage) + "%" + (Battery.charging ? "  ·  Charging" : "")
        font: Tokens.font.titleLarge
        color: Colours.palette.m3onSurface
    }

    Rectangle {
        Layout.fillWidth: true
        height: 10
        radius: 9999
        color: Colours.palette.m3surfaceContainerHighest

        Rectangle {
            width: parent.width * Math.max(0, Math.min(1, Battery.percentage / 100))
            height: parent.height
            radius: 9999
            color: Battery.charging ? Colours.palette.m3primary : Colours.palette.m3tertiary

            Behavior on width {
                Anim { type: Anim.DefaultSpatial }
            }
        }
    }
}
