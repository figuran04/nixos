pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property var model: DesktopEntries.applications

    function launch(entry) {
        if (entry) entry.execute();
    }
}
