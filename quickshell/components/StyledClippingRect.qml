import QtQuick

Rectangle {
    id: root

    clip: true

    Behavior on radius {
        NumberAnimation {
            duration: Tokens.anim.durations.expressiveDefaultSpatial
            easing: Tokens.anim.expressiveDefaultSpatial
        }
    }
}
