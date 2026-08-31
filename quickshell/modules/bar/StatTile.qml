import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../services"

// A labelled stat tile used in the dashboard popout.
ColumnLayout {
    id: root

    property string label: ""
    property string value: ""

    Layout.fillWidth: true
    Layout.minimumWidth: 120
    spacing: Tokens.spacing.nano

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 60
        radius: Tokens.rounding.medium
        color: Colours.withAlpha(Colours.palette.m3onSurface, 0.05)

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Tokens.padding.medium
            spacing: Tokens.spacing.nano

            StyledText {
                text: root.value
                font.pixelSize: 18
                fontWeight: Font.Bold
                textColor: Colours.palette.m3primary
            }

            StyledText {
                text: root.label
                font.pixelSize: 10
                textColor: Colours.palette.m3onSurfaceVariant
            }
        }
    }
}