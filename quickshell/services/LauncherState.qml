pragma Singleton
import QtQuick

// Shared visibility state for the application launcher overlay.
Singleton {
    id: root

    property bool active: false

    function toggle(): void {
        root.active = !root.active;
    }
}
