pragma Singleton

import Quickshell
import QtQuick

// Material 3 colour system (dark), tuned toward Noctalia's look.
// Access via Colours.palette.m3Xxx / Colours.withAlpha(...) / Colours.layer(...).
Singleton {
    id: root

    readonly property var palette: {
        "m3primary": "#95d5b2",
        "m3onPrimary": "#003828",
        "m3primaryContainer": "#0f5435",
        "m3onPrimaryContainer": "#b9f2ce",
        "m3secondary": "#a2ccb4",
        "m3onSecondary": "#0b3526",
        "m3secondaryContainer": "#254c3c",
        "m3onSecondaryContainer": "#bde8cf",
        "m3tertiary": "#a4cec3",
        "m3onTertiary": "#06372f",
        "m3tertiaryContainer": "#244f46",
        "m3onTertiaryContainer": "#c0eadf",
        "m3error": "#ffb4ab",
        "m3onError": "#690005",
        "m3errorContainer": "#93000a",
        "m3onErrorContainer": "#ffdad6",
        "m3surface": "#101512",
        "m3onSurface": "#dee4de",
        "m3surfaceVariant": "#404943",
        "m3onSurfaceVariant": "#c0c9c1",
        "m3surfaceContainer": "#1a211d",
        "m3surfaceContainerHigh": "#252c27",
        "m3surfaceContainerHighest": "#2f3731",
        "m3surfaceContainerLow": "#161c19",
        "m3surfaceContainerLowest": "#0b100d",
        "m3outline": "#8a948c",
        "m3outlineVariant": "#404943",
        "m3shadow": "#000000",
        "m3scrim": "#000000",
        "m3inverseSurface": "#dee4de",
        "m3inverseOnSurface": "#2f3731",
        "m3inversePrimary": "#2f6f4e",
    }

    // Return a color with its alpha overridden.
    function withAlpha(c, a) {
        return Qt.rgba(c.r, c.g, c.b, a);
    }

    // Blend a color onto a base background (as an overlay), producing a
    // color with the given target alpha over the material surface.
    function layer(c, a) {
        const base = root.palette.m3surface;
        const cb = Qt.rgba(base.r, base.g, base.b, base.a);
        const cc = Qt.rgba(c.r, c.g, c.b, c.a);
        const r = cc.r * a + cb.r * (1 - a);
        const g = cc.g * a + cb.g * (1 - a);
        const b = cc.b * a + cb.b * (1 - a);
        return Qt.rgba(r, g, b, cb.a);
    }
}
