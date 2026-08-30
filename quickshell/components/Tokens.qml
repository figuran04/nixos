pragma Singleton
import QtQuick

// Material 3 inspired design tokens, mirroring the feel of Caelestia
// but self-contained (no Caelestia C++ plugin required).
QtObject {
    id: root

    readonly property QtObject spacing: QtObject {
        readonly property int extraSmall: 4
        readonly property int small: 8
        readonly property int medium: 12
        readonly property int large: 16
        readonly property int extraLarge: 24
    }

    readonly property QtObject padding: QtObject {
        readonly property int extraSmall: 4
        readonly property int small: 8
        readonly property int medium: 12
        readonly property int large: 16
        readonly property int extraLarge: 24
    }

    readonly property QtObject rounding: QtObject {
        readonly property int extraSmall: 4
        readonly property int small: 8
        readonly property int medium: 12
        readonly property int large: 16
        readonly property int extraLarge: 28
        readonly property int full: 9999
    }

    readonly property QtObject sizes: QtObject {
        readonly property QtObject bar: QtObject {
            // Width of the vertical dock on the right side.
            readonly property int innerWidth: 76
            readonly property int outerWidth: 86
            readonly property int entrySize: 44
        }
    }

    readonly property QtObject font: QtObject {
        function make(opts): font {
            return Qt.font(Object.assign({ family: "Noto Sans" }, opts));
        }

        readonly property font bodySmall: make({ pixelSize: 11 })
        readonly property font bodyMedium: make({ pixelSize: 13 })
        readonly property font bodyLarge: make({ pixelSize: 15 })
        readonly property font labelLarge: make({ pixelSize: 14, weight: Font.DemiBold })
        readonly property font titleMedium: make({ pixelSize: 16, weight: Font.Medium })
        readonly property font titleLarge: make({ pixelSize: 22, weight: Font.Medium })

        readonly property font icon: make({ family: "Material Symbols Outlined", pixelSize: 22 })
        readonly property font iconSmall: make({ family: "Material Symbols Outlined", pixelSize: 18 })
        readonly property font iconMedium: make({ family: "Material Symbols Outlined", pixelSize: 26 })
        readonly property font iconLarge: make({ family: "Material Symbols Outlined", pixelSize: 32 })

        readonly property font mono: make({ family: "JetBrains Mono, monospace", pixelSize: 13 })
    }

    readonly property QtObject anim: QtObject {
        readonly property QtObject durations: QtObject {
            readonly property int normal: 200
            readonly property int small: 150
            readonly property int large: 300
            readonly property int extraLarge: 400
            readonly property int expressiveFastSpatial: 250
            readonly property int expressiveDefaultSpatial: 350
            readonly property int expressiveSlowSpatial: 450
            readonly property int expressiveFastEffects: 200
            readonly property int expressiveDefaultEffects: 300
            readonly property int expressiveSlowEffects: 500
        }

        readonly property int standard: Easing.OutCubic
        readonly property int emphasized: Easing.InOutCubic
        readonly property int expressiveFastSpatial: Easing.OutCubic
        readonly property int expressiveDefaultSpatial: Easing.OutCubic
        readonly property int expressiveSlowSpatial: Easing.OutCubic
        readonly property int expressiveFastEffects: Easing.OutCubic
        readonly property int expressiveDefaultEffects: Easing.OutCubic
        readonly property int expressiveSlowEffects: Easing.InOutCubic
    }
}
