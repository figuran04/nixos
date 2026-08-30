import QtQuick

QtObject {
    id: root

    property string currentName: ""
    readonly property bool hasCurrent: currentName !== ""

    function request(name: string): void {
        if (root.currentName === name)
            root.currentName = "";
        else
            root.currentName = name;
    }

    function close(): void {
        root.currentName = "";
    }
}
