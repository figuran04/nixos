pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    property bool visible: false

    function toggle() {
        root.visible = !root.visible;
    }

    function show() {
        root.visible = true;
    }

    function hide() {
        root.visible = false;
    }
}
