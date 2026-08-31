import QtQuick

// Adaptive rounded rectangle with per-corner control.
// Supports convex rounding AND concave (inverse / embossed) corner cuts,
// plus a border that follows the exact same shape (convex + concave),
// inspired by Noctalia's WrapperRectangle / ClippingRectangle panel borders,
// implemented with a Canvas so it needs no C++ shader plugin. All radii
// animate smoothly.
//
// Rendering technique: a single path is built containing the convex
// rounded-rectangle outline PLUS each concave corner's quarter-disc subpath.
// The panel is filled with the even-odd rule (concave discs become recessed
// holes) and the border is stroked along that same path so it hugs the exact
// panel shape, including the recessed corners.
Item {
    id: root

    property color color: "transparent"
    property color borderColor: "transparent"
    property real borderWidth: 0
    property real tlRadius: 0
    property real trRadius: 0
    property real blRadius: 0
    property real brRadius: 0
    property real tlConcave: 0
    property real trConcave: 0
    property real blConcave: 0
    property real brConcave: 0

    default property alias data: contentItem.data
    property alias children: contentItem.children
    readonly property alias contentItem: contentItem

    onColorChanged: canvas.requestPaint()
    onBorderColorChanged: canvas.requestPaint()
    onBorderWidthChanged: canvas.requestPaint()
    onTlRadiusChanged: canvas.requestPaint()
    onTrRadiusChanged: canvas.requestPaint()
    onBlRadiusChanged: canvas.requestPaint()
    onBrRadiusChanged: canvas.requestPaint()
    onTlConcaveChanged: canvas.requestPaint()
    onTrConcaveChanged: canvas.requestPaint()
    onBlConcaveChanged: canvas.requestPaint()
    onBrConcaveChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()

    Behavior on tlRadius {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on trRadius {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on blRadius {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on brRadius {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on tlConcave {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on trConcave {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on blConcave {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on brConcave {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing: Tokens.anim.expressiveDefaultSpatial }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            const w = width;
            const h = height;
            if (w <= 0 || h <= 0)
                return;

            const maxR = Math.min(w, h) / 2;
            const tl = Math.max(0, Math.min(root.tlRadius, maxR));
            const tr = Math.max(0, Math.min(root.trRadius, maxR));
            const br = Math.max(0, Math.min(root.brRadius, maxR));
            const bl = Math.max(0, Math.min(root.blRadius, maxR));
            const cTl = Math.max(0, Math.min(root.tlConcave, maxR));
            const cTr = Math.max(0, Math.min(root.trConcave, maxR));
            const cBr = Math.max(0, Math.min(root.brConcave, maxR));
            const cBl = Math.max(0, Math.min(root.blConcave, maxR));

            // ---- Build the combined outline path (outer rect + concave cuts) ----
            ctx.beginPath();

            // 1. Outer convex rounded rectangle (clockwise).
            ctx.moveTo(tl, 0);
            ctx.lineTo(w - tr, 0);
            if (tr > 0) ctx.quadraticCurveTo(w, 0, w, tr);
            else ctx.lineTo(w, 0);
            ctx.lineTo(w, h - br);
            if (br > 0) ctx.quadraticCurveTo(w, h, w - br, h);
            else ctx.lineTo(w, h);
            ctx.lineTo(bl, h);
            if (bl > 0) ctx.quadraticCurveTo(0, h, 0, h - bl);
            else ctx.lineTo(0, h);
            ctx.lineTo(0, tl);
            if (tl > 0) ctx.quadraticCurveTo(0, 0, tl, 0);
            else ctx.lineTo(0, 0);
            ctx.closePath();

            // 2. Concave quarter-disc punch-outs (even-odd holes at the corners).
            if (cTl > 0) { ctx.moveTo(0, 0); ctx.arc(0, 0, cTl, 0, Math.PI / 2, false); ctx.closePath(); }
            if (cTr > 0) { ctx.moveTo(w, 0); ctx.arc(w, 0, cTr, Math.PI / 2, Math.PI, false); ctx.closePath(); }
            if (cBr > 0) { ctx.moveTo(w, h); ctx.arc(w, h, cBr, Math.PI, -Math.PI / 2, false); ctx.closePath(); }
            if (cBl > 0) { ctx.moveTo(0, h); ctx.arc(0, h, cBl, -Math.PI / 2, 0, false); ctx.closePath(); }

            // ---- Fill the panel ----
            const bg = Qt.rgba(root.color.r, root.color.g, root.color.b, root.color.a);
            ctx.fillStyle = bg;
            ctx.fill("evenodd");

            // ---- Border hugging the exact same outline ----
            if (root.borderColor.a > 0 && root.borderWidth > 0) {
                const bc = Qt.rgba(root.borderColor.r, root.borderColor.g, root.borderColor.b, root.borderColor.a);
                ctx.strokeStyle = bc;
                ctx.lineWidth = Math.min(root.borderWidth, Math.min(w, h) / 2);
                ctx.stroke();
            }
        }
    }

    Item {
        id: contentItem
        anchors.fill: parent
    }
}
