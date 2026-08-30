import Quickshell
import QtQuick
import QtQuick.Layouts
import "../../components"
import "../../services"

PopupWindow {
    id: root

    // The PanelWindow this popup floats next to (the bar dock's owning window).
    required property var anchorWindow
    // Width of the whole panel window (usually the screen width).
    required property real panelWidth
    // Width of the dock so the popup can sit just left of it.
    required property real dockWidth

    color: "transparent"
    visible: Niri.focusedWindow != null && showTimer.running

    implicitWidth: content.implicitWidth + Tokens.padding.large * 2
    implicitHeight: content.implicitHeight + Tokens.padding.large * 2

    anchor.window: root.anchorWindow
    anchor.rect.x: root.panelWidth - root.dockWidth - root.implicitWidth - Tokens.spacing.medium
    anchor.rect.y: Tokens.padding.medium

    Connections {
        target: Niri
        function onFocusedWindowChanged(): void {
            if (Niri.focusedWindow != null)
                showTimer.restart();
            else
                showTimer.stop();
        }
    }

    Timer {
        id: showTimer
        interval: 2500
    }

    Behavior on opacity {
        Anim { type: Anim.DefaultEffects }
    }

    StyledRect {
        id: card

        anchors.fill: parent
        radius: Tokens.rounding.large
        color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 0.96)

        RowLayout {
            id: content

            anchors.fill: parent
            anchors.margins: Tokens.padding.large
            spacing: Tokens.spacing.medium

            Image {
                id: icon
                Layout.alignment: Qt.AlignVCenter
                width: 24
                height: 24
                source: Niri.focusedWindow?.app_id ? Icons.getAppIcon(Niri.focusedWindow.app_id, "image-missing") : ""
                sourceSize.width: 24
                sourceSize.height: 24
                fillMode: Image.PreserveAspectFit
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                spacing: 0

                StyledText {
                    Layout.fillWidth: true
                    text: Niri.focusedWindow?.title ?? ""
                    font: Tokens.font.bodyMedium
                    elide: Text.ElideRight
                    color: Colours.palette.m3onSurface
                }

                StyledText {
                    Layout.fillWidth: true
                    text: Niri.focusedWindow?.app_id ?? ""
                    font: Tokens.font.bodySmall
                    color: Colours.palette.m3onSurfaceVariant
                    elide: Text.ElideRight
                }
            }
        }
    }
}
