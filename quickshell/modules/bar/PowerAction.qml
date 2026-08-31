import QtQuick
import QtQuick.Layouts
import Quickshell
import "../components"
import "../services"

// A labelled action button used in the power popout.
Item {
    id: root

    signal clicked()
    property string text: ""
    property string action: ""

    Layout.fillWidth: true
    Layout.preferredHeight: 36

    Rectangle {
        anchors.fill: parent
        radius: Tokens.rounding.medium
        color: hov.hovered ? Colours.withAlpha(Colours.palette.m3onSurface, 0.08) : "transparent"

        Behavior on color {
            ColorAnimation { duration: Tokens.anim.durations.fast }
        }

        StyledText {
            anchors.fill: parent
            anchors.margins: Tokens.padding.small
            text: root.text
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            textColor: hov.hovered ? Colours.palette.m3primary : Colours.palette.m3onSurface
        }
    }

    HoverHandler { id: hov; hoverEnabled: true }

    TapHandler {
        onTapped: {
            root.clicked();
            if (root.action !== "") Quickshell.execDetached(["sh", "-c", root.action]);
        }
    }
}
