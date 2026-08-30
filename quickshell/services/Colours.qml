pragma Singleton
import QtQuick

// Static Material 3 palette generated from a single seed colour.
// Mirrors Caelestia's Colours.palette / tPalette API so components can be
// ported with minimal changes, but needs no C++ plugin and no wallpaper
// analysis. Tweak `seed` to recolour the entire shell.
Singleton {
    id: root

    // Change this to retheme everything.
    property color seed: "#7c5cff"
    property bool light: false

    function clamp(v, lo, hi): real {
        return Math.max(lo, Math.min(hi, v));
    }

    function hsl(h, s, l): color {
        h = ((h % 360) + 360) % 360;
        return Qt.hsla(h / 360, clamp(s, 0, 1), clamp(l, 0, 1), 1);
    }

    function compute(): var {
        const rgb = root.seed;
        const r = rgb.r, g = rgb.g, b = rgb.b;
        const max = Math.max(r, g, b), min = Math.min(r, g, b);
        let h = 0;
        const d = max - min;
        if (d !== 0) {
            if (max === r) h = ((g - b) / d) % 6;
            else if (max === g) h = (b - r) / d + 2;
            else h = (r - g) / d + 4;
            h *= 60;
        }
        const s = max === 0 ? 0 : d / max;
        const H = h;
        const chroma = clamp(Math.max(0.35, s), 0.35, 0.85);
        const k = chroma * 0.4;

        const dark = !root.light;
        const t = dark ? {
            surface: 0.06, onSurface: 0.90,
            surfVar: 0.30, onSurfVar: 0.80,
            out: 0.50, outVar: 0.30,
            scLowest: 0.04, scLow: 0.10, sc: 0.12, scHigh: 0.17, scHighest: 0.22,
            prim: 0.80, onPrim: 0.20, primC: 0.30, onPrimC: 0.90,
            invSurf: 0.90, invOnSurf: 0.20, invPrim: 0.40
        } : {
            surface: 0.98, onSurface: 0.10,
            surfVar: 0.88, onSurfVar: 0.30,
            out: 0.50, outVar: 0.80,
            scLowest: 1.0, scLow: 0.96, sc: 0.94, scHigh: 0.92, scHighest: 0.90,
            prim: 0.40, onPrim: 1.0, primC: 0.90, onPrimC: 0.10,
            invSurf: 0.20, invOnSurf: 0.95, invPrim: 0.80
        };

        const p = {};
        p.m3primary = hsl(H, chroma, t.prim);
        p.m3onPrimary = hsl(H, chroma, t.onPrim);
        p.m3primaryContainer = hsl(H, chroma, t.primC);
        p.m3onPrimaryContainer = hsl(H, chroma, t.onPrimC);
        p.m3secondary = hsl(H, k, t.prim);
        p.m3onSecondary = hsl(H, k, t.onPrim);
        p.m3secondaryContainer = hsl(H, k, t.primC);
        p.m3onSecondaryContainer = hsl(H, k, t.onPrimC);
        p.m3tertiary = hsl(H + 60, chroma * 0.6, t.prim);
        p.m3onTertiary = hsl(H + 60, chroma * 0.6, t.onPrim);
        p.m3tertiaryContainer = hsl(H + 60, chroma * 0.6, t.primC);
        p.m3onTertiaryContainer = hsl(H + 60, chroma * 0.6, t.onPrimC);
        p.m3surface = hsl(H, 0.05, t.surface);
        p.m3onSurface = hsl(H, 0.05, t.onSurface);
        p.m3surfaceVariant = hsl(H, 0.10, t.surfVar);
        p.m3onSurfaceVariant = hsl(H, 0.10, t.onSurfVar);
        p.m3outline = hsl(H, 0.12, t.out);
        p.m3outlineVariant = hsl(H, 0.10, t.outVar);
        p.m3surfaceContainerLowest = hsl(H, 0.04, t.scLowest);
        p.m3surfaceContainerLow = hsl(H, 0.04, t.scLow);
        p.m3surfaceContainer = hsl(H, 0.04, t.sc);
        p.m3surfaceContainerHigh = hsl(H, 0.04, t.scHigh);
        p.m3surfaceContainerHighest = hsl(H, 0.04, t.scHighest);
        p.m3inverseSurface = hsl(H, 0.05, t.invSurf);
        p.m3inverseOnSurface = hsl(H, 0.05, t.invOnSurf);
        p.m3inversePrimary = hsl(H, chroma, t.invPrim);
        p.m3error = hsl(0, 0.7, t.prim);
        p.m3onError = hsl(0, 0.7, t.onPrim);
        p.m3errorContainer = hsl(0, 0.7, t.primC);
        p.m3onErrorContainer = hsl(0, 0.7, t.onPrimC);
        p.m3shadow = "#000000";
        p.m3scrim = "#000000";
        return p;
    }

    property var _palette: compute()
    readonly property var palette: _palette
    readonly property var tPalette: _palette

    onSeedChanged: _palette = compute()
    onLightChanged: _palette = compute()

    function withAlpha(c: color, a: real): color {
        return Qt.alpha(c, a);
    }

    // Returns the colour with the given alpha applied (mirrors Caelestia's API).
    function layer(c: color, a: real): color {
        return Qt.alpha(c, a);
    }
}
