import QtQuick
import "../../components"
import "../../services"

// Power / lock entry at the bottom of the dock.
Entry {
    id: root

    property QtObject store: null
    signal openPower()

    icon: "power_settings_new"
    colour: Colours.palette.m3onSurfaceVariant
    active: root.store ? root.store.currentName === "power" : false
    onClicked: root.openPower()
}
