import QtQuick
import "../components"
import "../services"

// Standard styled text using the shell's font + onSurface colour.
Text {
    id: root

    property color textColor: Colours.palette.m3onSurface
    property int fontWeight: Font.Normal

    color: root.textColor
    font.family: Tokens.fontFamily
    font.weight: root.fontWeight
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignLeft
    renderType: Text.NativeRendering
}
