import QtQuick
import QtQuick.Layouts
import Quickshell
import "../../../components"
import "../../../services"

ColumnLayout {
    id: root

    required property var popoutState
    property var screen

    spacing: Tokens.spacing.medium
    implicitWidth: 240
    implicitHeight: col.implicitHeight

    StyledText {
        text: "Power"
        font: Tokens.font.titleMedium
        color: Colours.palette.m3onSurface
    }

    Action {
        icon: "lock"
        label: "Lock"
        action: {
            Quickshell.execDetached(["loginctl", "lock-session"]);
            root.popoutState.close();
        }
    }

    Action {
        icon: "bedtime"
        label: "Suspend"
        action: {
            Quickshell.execDetached(["systemctl", "suspend"]);
            root.popoutState.close();
        }
    }

    Action {
        icon: "logout"
        label: "Log Out"
        action: {
            Quickshell.execDetached(["bash", "-c", "loginctl terminate-session $XDG_SESSION_ID"]);
            root.popoutState.close();
        }
    }

    Action {
        icon: "restart_alt"
        label: "Restart"
        action: {
            Quickshell.execDetached(["systemctl", "reboot"]);
            root.popoutState.close();
        }
    }

    Action {
        icon: "power_settings_new"
        label: "Power Off"
        action: {
            Quickshell.execDetached(["systemctl", "poweroff"]);
            root.popoutState.close();
        }
    }

    component Action: Item {
        required property string icon
        required property string label
        required property var action

        implicitWidth: 240 - Tokens.padding.large * 2
        implicitHeight: row.implicitHeight

        RowLayout {
            id: row

            anchors.fill: parent
            spacing: Tokens.spacing.medium

            MaterialIcon {
                text: parent.icon
                color: Colours.palette.m3onSurfaceVariant
            }

            StyledText {
                Layout.fillWidth: true
                text: parent.label
                color: Colours.palette.m3onSurface
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.opacity = 0.7
            onExited: parent.opacity = 1
            onClicked: parent.action()
        }

        Behavior on opacity {
            Anim { type: Anim.DefaultEffects }
        }
    }
}
