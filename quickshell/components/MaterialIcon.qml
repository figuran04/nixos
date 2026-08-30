pragma ComponentBehavior: Bound

import QtQuick
import qs.services
import qs.components

StyledText {
    property real fill: 0
    property int grade: Colours.light ? 0 : -25
    property font fontStyle: Tokens.font.iconSmall

    font: fontStyle
    color: Colours.palette.m3onSurface
}
