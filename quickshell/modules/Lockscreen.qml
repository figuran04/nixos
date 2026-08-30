import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import "../components"
import "../services"

WlSessionLock {
    id: lock

    IpcHandler {
        target: "lockscreen"
        function lock() { lock.locked = true }
        function unlock() { lock.locked = false }
    }

    WlSessionLockSurface {
        Rectangle {
            anchors.fill: parent
            color: Colours.layer(Colours.palette.m3surfaceContainerLowest, 0.85)
        }

        StyledRect {
            anchors.centerIn: parent
            radius: Tokens.rounding.extraLarge
            color: Colours.palette.m3surfaceContainerHigh
            implicitWidth: 320
            implicitHeight: card.implicitHeight + Tokens.padding.large * 2

            ColumnLayout {
                id: card

                anchors.centerIn: parent
                anchors.margins: Tokens.padding.large
                spacing: Tokens.spacing.medium

                MaterialIcon {
                    Layout.alignment: Qt.AlignHCenter
                    text: "lock"
                    color: Colours.palette.m3primary
                    fontStyle: Tokens.font.iconLarge
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: Time.time
                    font: Tokens.font.titleLarge
                    color: Colours.palette.m3onSurface
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: Time.date
                    font: Tokens.font.bodyLarge
                    color: Colours.palette.m3onSurfaceVariant
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: Tokens.spacing.small
                    text: "Session locked"
                    font: Tokens.font.bodyMedium
                    color: Colours.palette.m3onSurfaceVariant
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: lock.locked = false
        }
    }
}
