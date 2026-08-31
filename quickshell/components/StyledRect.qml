import QtQuick
import "../services"

// Rectangle with animated color and native per-corner radius support
// (Rectangle.topLeftRadius / topRightRadius / bottomLeftRadius /
// bottomRightRadius), mirroring the flexibility of Noctalia's
// WrapperRectangle/ClippingRectangle without needing C++ shaders.
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
