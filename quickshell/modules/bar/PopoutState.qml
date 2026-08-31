import QtQuick

QtObject {
    id: root

    property string currentName: ""
    property string currentSide: ""
    readonly property bool hasCurrent: currentName !== ""

    function request(name: string, side: string = "left"): void {
        if (root.currentName === name) {
            root.currentName = "";
            root.currentSide = "";
        } else {
            root.currentName = name;
            root.currentSide = side;
        }
    }

    function close(): void {
        root.currentName = "";
        root.currentSide = "";
    }
}
