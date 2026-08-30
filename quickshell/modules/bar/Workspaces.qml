import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../services"

StyledRect {
    id: root

    color: Colours.palette.m3surfaceContainer
    radius: Tokens.rounding.full
    implicitWidth: col.implicitWidth + Tokens.padding.medium * 2
    implicitHeight: col.implicitHeight + Tokens.padding.medium * 2

    readonly property int entry: Tokens.sizes.bar.innerWidth - Tokens.padding.medium * 2

    ColumnLayout {
        id: col

        anchors.fill: parent
        anchors.margins: Tokens.padding.medium
        spacing: Tokens.spacing.small

        Repeater {
            model: Niri.workspaces

            ColumnLayout {
                id: ws

                required property var modelData

                Layout.alignment: Qt.AlignHCenter
                spacing: Tokens.spacing.extraSmall

                // Workspace pill: click to focus the workspace.
                Rectangle {
                    id: pill
                    Layout.alignment: Qt.AlignHCenter
                    width: root.entry
                    height: root.entry
                    radius: Tokens.rounding.full
                    color: modelData.is_active ? Colours.palette.m3primary : "transparent"
                    border.color: modelData.is_active ? "transparent" : Colours.palette.m3outlineVariant
                    border.width: 1

                    StyledText {
                        anchors.centerIn: parent
                        text: String(modelData.idx + 1)
                        font: Tokens.font.bodyMedium
                        color: modelData.is_active ? Colours.palette.m3onPrimary : Colours.palette.m3onSurfaceVariant
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Niri.focusWorkspace(modelData.idx)
                    }
                }

                // App icons for windows on this workspace.
                Repeater {
                    model: Niri.windowsOn(modelData.id)

                    Rectangle {
                        id: icon
                        required property var modelData

                        Layout.alignment: Qt.AlignHCenter
                        width: root.entry
                        height: root.entry
                        radius: Tokens.rounding.full
                        color: modelData.id === Niri.focusedWindowId ? Colours.palette.m3secondaryContainer : "transparent"
                        border.color: "transparent"
                        border.width: 0

                        Image {
                            anchors.centerIn: parent
                            width: 18
                            height: 18
                            source: Icons.getAppIcon(modelData.app_id ?? "", "")
                            sourceSize.width: 18
                            sourceSize.height: 18
                            fillMode: Image.PreserveAspectFit
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Niri.focusWindow(modelData.id)
                        }
                    }
                }
            }
        }
    }
}
