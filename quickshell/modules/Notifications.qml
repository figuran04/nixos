import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import "../components"
import "../services"

// Notification service + display panel (stacked, adaptive corners).
Scope {
    id: root

    NotificationServer {
        id: notifications

        // Advertise + track notifications.
        bodySupported: true
        bodyMarkupSupported: false
        persistenceSupported: true
        actionsSupported: true
        imageSupported: true
        bodyImagesSupported: true

        onNotification: function (n) {
            n.tracked = true;
        }
    }

    PanelWindow {
        id: panel

        anchors.right: true
        anchors.top: true

        color: "transparent"
        exclusiveZone: 0

        implicitWidth: 360
        visible: notifications.trackedNotifications.length > 0
        opacity: visible ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: Tokens.anim.durations.fast }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Tokens.padding.large
            spacing: Tokens.spacing.small

            Repeater {
                model: notifications.trackedNotifications

                NotificationCard {
                    required property var modelData
                    Layout.fillWidth: true
                    notification: modelData
                }
            }
        }
    }
}