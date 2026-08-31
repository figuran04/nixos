import QtQuick
import QtQuick.Layouts
import "../components"
import "../services"

// System dashboard popout.
ColumnLayout {
    id: root

    spacing: Tokens.spacing.standard
    anchors.fill: parent

    StyledText {
        text: SysInfo.hostname || "system"
        font.pixelSize: 14
        fontWeight: Font.Bold
        horizontalAlignment: Text.AlignHCenter
        Layout.fillWidth: true
    }

    GridLayout {
        Layout.fillWidth: true
        columns: 2
        columnSpacing: Tokens.spacing.medium
        rowSpacing: Tokens.spacing.medium

        StatTile { label: "CPU"; value: SysInfo.cpuLoad }
        StatTile { label: "RAM"; value: SysInfo.memUsed }
    }
}