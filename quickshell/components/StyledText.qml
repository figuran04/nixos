pragma ComponentBehavior: Bound

import QtQuick
import qs.services
import qs.components

Text {
    id: root

    property bool animate: false

    renderType: Text.NativeRendering
    textFormat: Text.PlainText
    color: Colours.palette.m3onSurface
    font: Tokens.font.bodySmall

    Behavior on color {
        ColorAnimation {
            duration: Tokens.anim.durations.expressiveSlowEffects
            easing: Tokens.anim.expressiveSlowEffects
        }
    }

    Behavior on text {
        enabled: root.animate

        SequentialAnimation {
            PropertyAnimation {
                target: root
                property: "opacity"
                to: 0
                duration: Tokens.anim.durations.expressiveFastEffects / 2
                easing: Tokens.anim.expressiveFastEffects
            }
            PropertyAction {}
            PropertyAnimation {
                target: root
                property: "opacity"
                to: 1
                duration: Tokens.anim.durations.expressiveDefaultEffects
                easing: Tokens.anim.expressiveDefaultEffects
            }
        }
    }
}
