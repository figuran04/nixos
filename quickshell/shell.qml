import Quickshell
import QtQuick
import "components"
import "modules"

// Root for the Noctalia-style niriquickshell.
// Hosts the per-screen dock bar plus the floating overlays (osd,
// notifications, launcher, lockscreen).
ShellRoot {
    id: root

    Bar {}

    Osd {}

    Notifications {}

    Launcher {}

    Lockscreen {}
}
