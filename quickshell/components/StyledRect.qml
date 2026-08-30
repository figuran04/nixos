import QtQuick
import qs.components

Rectangle {
    id: root

    color: "transparent"

    Behavior on color {
        ColorAnimation {
            duration: Tokens.anim.durations.expressiveSlowEffects
            easing: Tokens.anim.expressiveSlowEffects
        }
    }
}
