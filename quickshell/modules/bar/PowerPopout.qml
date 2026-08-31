import QtQuick
import QtQuick.Layouts
import "../components"
import "../services"

// Power menu popout.
ColumnLayout {
    id: root

    spacing: Tokens.spacing.medium
    anchors.fill: parent

    StyledText {
        text: "Power"
        font.pixelSize: 14
        fontWeight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        Layout.fillWidth: true
    }

    PowerAction { text: "Sleep"; action: "loginctl suspend" }
    PowerAction { text: "Reboot"; action: "systemctl reboot" }
    PowerAction { text: "Power off"; action: "systemctl poweroff" }
    PowerAction { text: "Log out"; action: "niri msg action quit" }
}
