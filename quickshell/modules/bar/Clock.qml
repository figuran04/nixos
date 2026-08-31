import QtQuick
import QtQuick.Layouts
import "../services"
import "../components"

// Vertical time + date display for the dock.
ColumnLayout {
    id: root

    spacing: Tokens.spacing.nano
    Layout.alignment: Qt.AlignHCenter

    StyledText {
        text: Time.time
        font.pixelSize: 18
        fontWeight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        Layout.alignment: Qt.AlignHCenter
    }

    StyledText {
        text: Time.date
        font.pixelSize: 10
        textColor: Colours.palette.m3onSurfaceVariant
        horizontalAlignment: Text.AlignHCenter
        Layout.alignment: Qt.AlignHCenter
    }
}
