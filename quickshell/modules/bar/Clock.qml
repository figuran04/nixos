import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../services"

Item {
    id: root

    implicitWidth: Tokens.sizes.bar.innerWidth
    implicitHeight: col.implicitHeight + Tokens.padding.medium * 2

    readonly property var parts: Time.time.split(":")
    readonly property string hour: parts[0] ?? ""
    readonly property string minute: parts[1] ?? ""
    readonly property var dateParts: Time.date.split(" ")
    readonly property string weekday: dateParts[0] ?? ""

    ColumnLayout {
        id: col

        anchors.centerIn: parent
        spacing: 2

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: root.weekday
            font: Tokens.font.bodySmall
            color: Colours.palette.m3tertiary
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            text: root.hour
            font: Tokens.font.titleLarge
            color: Colours.palette.m3tertiary
        }

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: -6
            text: root.minute
            font: Tokens.font.titleLarge
            color: Colours.palette.m3tertiary
        }
    }
}
