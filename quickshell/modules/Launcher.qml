import Quickshell
import QtQuick
import QtQuick.Layouts
import "../components"
import "../services"

// App launcher overlay.
PanelWindow {
    id: root

    color: "transparent"
    exclusiveZone: 0

    anchors.top: true
    anchors.left: true
    anchors.right: true
    anchors.bottom: true

    visible: LauncherState.visible
    opacity: visible ? 1 : 0

    Behavior on opacity {
        NumberAnimation { duration: Tokens.anim.durations.expressiveDefaultSpatial; easing.type: Tokens.anim.expressiveDefaultSpatial }
    }

    AdaptiveRoundedRect {
        anchors.centerIn: parent
        width: Math.min(480, parent.width * 0.6)
        height: Math.min(500, parent.height * 0.7)

        color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 0.97)
        borderColor: Colours.withAlpha(Colours.palette.m3outline, 0.35)
        borderWidth: 1
        tlRadius: Tokens.rounding.extraLarge
        trRadius: Tokens.rounding.extraLarge
        blRadius: Tokens.rounding.extraLarge
        brRadius: Tokens.rounding.extraLarge

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Tokens.padding.large
            spacing: Tokens.spacing.medium

            Rectangle {
                Layout.fillWidth: true
                height: 36
                radius: Tokens.rounding.pill
                color: Colours.withAlpha(Colours.palette.m3onSurface, 0.05)
                border.color: Colours.withAlpha(Colours.palette.m3outline, 0.2)
                border.width: 1

                TextInput {
                    id: searchInput
                    anchors.fill: parent
                    anchors.leftMargin: Tokens.padding.medium
                    anchors.rightMargin: Tokens.padding.medium
                    verticalAlignment: Text.AlignVCenter
                    color: Colours.palette.m3onSurface
                    font.family: Tokens.fontFamily
                    font.pixelSize: 13
                    focus: true
                    clip: true
                    Keys.onEscapePressed: LauncherState.hide()

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: parent.anchors.leftMargin
                        verticalAlignment: Text.AlignVCenter
                        text: "Search apps..."
                        color: Colours.palette.m3onSurfaceVariant
                        font: searchInput.font
                        visible: searchInput.text === "" && !searchInput.activeFocus
                    }
                }
            }

            Flickable {
                id: appList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                contentWidth: flow.width
                contentHeight: flow.height

                Flow {
                    id: flow
                    width: appList ? appList.width : 0
                    spacing: Tokens.spacing.small

                    Repeater {
                        model: {
                            const q = searchInput.text.toLowerCase();
                            const all = Apps.model;
                            const out = [];
                            for (let i = 0; i < all.length; i++) {
                                const e = all[i];
                                const name = (e.name || "").toLowerCase();
                                if (q === "" || name.indexOf(q) !== -1) {
                                    out.push(e);
                                }
                            }
                            return out;
                        }

                        delegate: Item {
                            required property var modelData

                            width: 80
                            height: 80

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: Tokens.spacing.small
                                spacing: Tokens.spacing.small

                                MaterialIcon {
                                    icon: modelData.icon || "apps"
                                    iconSize: 32
                                    iconColor: Colours.palette.m3primary
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                StyledText {
                                    text: modelData.name || modelData.id || ""
                                    font.pixelSize: 9
                                    horizontalAlignment: Text.AlignHCenter
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                    maximumLineCount: 2
                                    wrapMode: Text.WordWrap
                                }
                            }

                            TapHandler {
                                onTapped: {
                                    Apps.launch(modelData);
                                    LauncherState.hide();
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    onActiveChanged: if (!active) LauncherState.hide()
}