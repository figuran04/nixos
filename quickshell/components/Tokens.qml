pragma Singleton

import QtQuick

// Central design tokens for the shell, mirroring Noctalia's Material 3 look.
// All spacing, sizes, corners, animations and fonts are controlled from here.
Singleton {
    id: tokens

    objectName: "tokens"

    // ---- Corner radii ----
    readonly property var rounding: {
        "small": 6,
        "medium": 12,
        "large": 18,
        "extraLarge": 28,
        "pill": 9999
    }

    // ---- Spacing scale ----
    readonly property var spacing: {
        "nano": 2,
        "micro": 4,
        "small": 6,
        "medium": 8,
        "standard": 12,
        "large": 16,
        "extraLarge": 20
    }

    // ---- Padding scale ----
    readonly property var padding: {
        "small": 6,
        "medium": 10,
        "large": 14,
        "extraLarge": 18
    }

    // ---- Sizes ----
    readonly property var sizes: {
        "bar": {
            "innerWidth": 44,
            "iconSize": 20,
        },
        "popout": {
            "iconSize": 22,
        },
    }

    // ---- Animation ----
    readonly property var anim: {
        "expressiveDefaultSpatial": Easing.OutCubic,
        "durations": {
            "fast": 120,
            "default": 200,
            "expressiveDefaultSpatial": 280,
            "slow": 400,
        },
    }

    // ---- Fonts ----
    readonly property string fontFamily: "JetBrains Mono"
}
