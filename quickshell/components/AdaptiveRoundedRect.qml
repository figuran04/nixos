import QtQuick

// Adaptive rounded rectangle with per-corner control.
// Supports convex rounding AND concave (inverse / embossed) corner cuts,
// inspired by Noctalia's flexible panel shapes, implemented with a Canvas
// so it needs no C++ shader plugin. All radii animate smoothly.
//
// Rendering technique: the full convex rounded-rectangle outline is drawn
// first, then each concave corner is punched out with a quarter-disc subpath
// (centred on the corner, spanning its two edges) using the even-odd fill
// rule. This cleanly creates a recessed / embossed corner exactly like a
// Noctalia panel merging with its popout partner, without needing to know
// the background colour.
Item {
    id: root

    property color color: "transparent"
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

            ctx.beginPath();

            // ---- 1. Outer convex rounded rectangle (clockwise) ----
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

            // ---- 2. Concave corner punch-outs (even-odd) ----
            // Each is a quarter-disc centred ON the corner point (radius r)
            // spanning the two adjacent edges; as a subpath with the even-odd
            // fill rule it carves a recessed / embossed corner out of the panel.
            if (cTl > 0) { ctx.moveTo(0, 0); ctx.arc(0, 0, cTl, 0, Math.PI / 2, false); ctx.closePath(); }
            if (cTr > 0) { ctx.moveTo(w, 0); ctx.arc(w, 0, cTr, Math.PI / 2, Math.PI, false); ctx.closePath(); }
            if (cBr > 0) { ctx.moveTo(w, h); ctx.arc(w, h, cBr, Math.PI, -Math.PI / 2, false); ctx.closePath(); }
            if (cBl > 0) { ctx.moveTo(0, h); ctx.arc(0, h, cBl, -Math.PI / 2, 0, false); ctx.closePath(); }

            ctx.fillStyle = Qt.rgba(root.color.r, root.color.g, root.color.b, root.color.a);
            ctx.fill("evenodd");
        }
    }

    Item {
        id: contentItem
        anchors.fill: parent
    }
}
