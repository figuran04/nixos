import QtQuick

// Tracks which popout panel is currently open, per bar instance.
QtObject {
    id: root

    property string currentName: ""
    property string currentSide: "left"

    readonly property bool hasCurrent: root.currentName !== ""

    function request(name, side) {
        if (root.currentName === name) {
            root.currentName = "";
        } else {
            root.currentName = name;
            root.currentSide = side;
        }
    }

    function close() {
        root.currentName = "";
    }

    function toggle(name) {
        if (root.currentName === name) {
            root.currentName = "";
        } else {
            root.currentName = name;
        }
    }
}
