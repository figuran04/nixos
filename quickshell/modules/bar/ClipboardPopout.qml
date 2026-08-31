import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../services"

// Clipboard history popout.
ColumnLayout {
    id: root

    spacing: Tokens.spacing.small
    anchors.fill: parent

    StyledText {
        text: "Clipboard"
        font.pixelSize: 14
        fontWeight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        Layout.fillWidth: true
    }

    ListView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        model: Clipboard.entries
        spacing: Tokens.spacing.small

        delegate: Rectangle {
            required property var modelData
            width: parent ? parent.width : 0
            height: 28
            radius: Tokens.rounding.small
            color: hov.hovered ? Colours.withAlpha(Colours.palette.m3onSurface, 0.08) : "transparent"

            StyledText {
                anchors.fill: parent
                anchors.margins: Tokens.padding.small
                text: {
                    const c = modelData ? (modelData.content || modelData) : "";
                    return c.length > 48 ? c.substring(0, 48) + "…" : c;
                }
                font.pixelSize: 11
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            HoverHandler { id: hov }
        }
    }
}