import QtQuick
import QtQuick.Layouts
import "../../../components"
import "../../../services"

ColumnLayout {
    id: root

    spacing: Tokens.spacing.medium
    implicitWidth: 300
    implicitHeight: Math.min(360, (Clipboard.entries.length ? Clipboard.entries.length : 1) * 44 + 56)

    RowLayout {
        StyledText {
            text: "Clipboard"
            font: Tokens.font.titleMedium
            color: Colours.palette.m3onSurface
        }

        Item {
            Layout.fillWidth: true
        }

        StyledText {
            text: Clipboard.entries.length
            color: Colours.palette.m3onSurfaceVariant
            font: Tokens.font.bodySmall
        }

        MouseArea {
            implicitWidth: 24
            implicitHeight: 24

            MaterialIcon {
                anchors.centerIn: parent
                text: "delete"
                color: Colours.palette.m3onSurfaceVariant
            }

            onClicked: Clipboard.clear()
        }
    }

    Flickable {
        Layout.fillWidth: true
        Layout.fillHeight: true
        contentHeight: col.implicitHeight
        clip: true
        interactive: Clipboard.entries.length > 4

        ColumnLayout {
            id: col
            width: parent.width
            spacing: Tokens.spacing.extraSmall

            Repeater {
                model: Clipboard.entries

                Rectangle {
                    required property var modelData

                    Layout.fillWidth: true
                    implicitHeight: 40
                    radius: Tokens.rounding.extraSmall
                    color: "transparent"

                    StyledText {
                        anchors.left: parent.left
                        anchors.leftMargin: Tokens.padding.small
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.text
                        font: Tokens.font.bodySmall
                        color: Colours.palette.m3onSurfaceVariant
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: parent.color = Colours.palette.m3surfaceContainerHigh
                        onExited: parent.color = "transparent"
                        onClicked: Clipboard.copy(modelData.text)
                    }
                }
            }
        }
    }
}
