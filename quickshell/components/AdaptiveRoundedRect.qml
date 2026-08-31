import QtQuick
import "../components"

// Adaptive rounded rectangle with per-corner control.
// Supports convex rounding AND concave (inverse/embossed) corner cuts, plus a
// border that follows the exact same shape — Noctalia's panel look, done in
// pure QML via a Canvas (no C++ shader plugin required). All radii and the
// border animate smoothly.
//
// Rendering: a single path is built from the convex rounded outline plus each
// concave corner's quarter-disc subpath. It is filled with the even-odd rule
// (concave discs become recessed notches) and the border is stroked along the
// same combined path, so it hugs the panel including the recessed corners.
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
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing.type: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on trRadius {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing.type: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on blRadius {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing.type: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on brRadius {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing.type: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on tlConcave {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing.type: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on trConcave {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing.type: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on blConcave {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing.type: Tokens.anim.expressiveDefaultSpatial }
    }
    Behavior on brConcave {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing.type: Tokens.anim.expressiveDefaultSpatial }
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
            const bw = Math.max(0, Math.min(root.borderWidth, maxR));

            // Builds the (possibly expanded/contracted) shape path: the convex
            // rounded outline plus a quarter-disc subpath per concave corner.
            // Even-odd makes the discs into recessed notches. `o` offsets every
            // edge/radius/disc outward (+bw → border ring, -bw → interior).
            function buildPath(o) {
                const tl = Math.max(0, root.tlRadius + o);
                const tr = Math.max(0, root.trRadius + o);
                const br = Math.max(0, root.brRadius + o);
                const bl = Math.max(0, root.blRadius + o);
                const cTl = Math.max(0, root.tlConcave + o);
                const cTr = Math.max(0, root.trConcave + o);
                const cBr = Math.max(0, root.brConcave + o);
                const cBl = Math.max(0, root.blConcave + o);

                ctx.moveTo(tl, -o);
                ctx.lineTo(w - tr, -o);
                if (tr > 0) ctx.quadraticCurveTo(w + o, -o, w + o, tr); else ctx.lineTo(w + o, -o);
                ctx.lineTo(w + o, h - br);
                if (br > 0) ctx.quadraticCurveTo(w + o, h + o, w - br, h + o); else ctx.lineTo(w + o, h + o);
                ctx.lineTo(bl, h + o);
                if (bl > 0) ctx.quadraticCurveTo(-o, h + o, -o, h - bl); else ctx.lineTo(-o, h + o);
                ctx.lineTo(-o, tl);
                if (tl > 0) ctx.quadraticCurveTo(-o, -o, tl, -o); else ctx.lineTo(-o, -o);

                if (cTl > 0) { ctx.moveTo(-o, -o); ctx.arc(-o, -o, cTl, 0, Math.PI / 2, false); ctx.closePath(); }
                if (cTr > 0) { ctx.moveTo(w + o, -o); ctx.arc(w + o, -o, cTr, Math.PI / 2, Math.PI, false); ctx.closePath(); }
                if (cBr > 0) { ctx.moveTo(w + o, h + o); ctx.arc(w + o, h + o, cBr, Math.PI, -Math.PI / 2, false); ctx.closePath(); }
                if (cBl > 0) { ctx.moveTo(-o, h + o); ctx.arc(-o, h + o, cBl, -Math.PI / 2, 0, false); ctx.closePath(); }

                ctx.closePath();
            }

            const hasBorder = root.borderColor.a > 0 && bw > 0;

            // Border ring: painted expanded shape, then interior contracted shape
            // even-odd on top leaves only the annulus hugging the exact outline
            // (including the inside of each concave notch).
            if (hasBorder) {
                ctx.fillStyle = root.borderColor;
                ctx.beginPath();
                buildPath(bw);
                ctx.fill("evenodd");

                ctx.fillStyle = root.color;
                ctx.beginPath();
                buildPath(-bw);
                ctx.fill("evenodd");
            } else {
                ctx.fillStyle = root.color;
                ctx.beginPath();
                buildPath(0);
                ctx.fill("evenodd");
            }
        }
    }

    Item {
        id: contentItem
        anchors.fill: parent
    }
}
