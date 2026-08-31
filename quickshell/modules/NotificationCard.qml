import QtQuick
import QtQuick.Layouts
import "../components"
import "../services"

// A single notification card.
Rectangle {
    id: root

    required property var notification

    height: cardContent.height + Tokens.padding.medium * 2
    radius: Tokens.rounding.medium
    color: Colours.withAlpha(Colours.palette.m3onSurface, 0.05)
    border.color: Colours.withAlpha(Colours.palette.m3outline, 0.35)
    border.width: 1

    ColumnLayout {
        id: cardContent
        anchors.fill: parent
        anchors.margins: Tokens.padding.medium
        spacing: Tokens.spacing.small

        StyledText {
            text: root.notification ? root.notification.summary : ""
            font.pixelSize: 13
            fontWeight: Font.Bold
            Layout.fillWidth: true
            elide: Text.ElideRight
        }

        StyledText {
            text: root.notification ? root.notification.body : ""
            font.pixelSize: 11
            textColor: Colours.palette.m3onSurfaceVariant
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            maximumLineCount: 4
            elide: Text.ElideRight
        }
    }

    TapHandler {
        onTapped: root.notification.dismiss()
    }
}