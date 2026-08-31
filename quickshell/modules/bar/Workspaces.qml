import QtQuick
import "../../services"
import "../../components"

// Vertical workspace indicator for Niri, filtered to the bar's own output.
Column {
    id: root

    property string screenName: ""

    spacing: Tokens.spacing.small

    // JS arrays have no change notification, so rebuild (and thus re-evaluate)
    // whenever the service repoints its `workspaces` array.
    readonly property var modelData: {
        const all = Niri.workspaces;
        if (root.screenName === "") return all;
        const out = [];
        for (let i = 0; i < all.length; i += 1) {
            if (all[i].output === root.screenName) out.push(all[i]);
        }
        return out;
    }

    Repeater {
        model: root.modelData

        Item {
            id: ws
            required property var modelData

            width: 16
            height: 4
            radius: 2

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                color: modelData.isActive
                    ? Colours.palette.m3primary
                    : modelData.isUrgent
                        ? Colours.palette.m3error
                        : Colours.withAlpha(Colours.palette.m3onSurfaceVariant, 0.4)

                Behavior on color {
                    ColorAnimation { duration: Tokens.anim.durations.fast }
                }
            }

            TapHandler {
                onTapped: Niri.focusWorkspace(modelData.id)
            }
        }
    }
}
