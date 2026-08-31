import Quickshell
import QtQuick
import QtQuick.Layouts
import "../components"
import "../services"

Scope {
    id: root

    readonly property string emptyText: "Search apps..."

    Variants {
        model: Quickshell.screens

        PopupWindow {
            id: win

            required property var modelData
            screen: modelData

            visible: LauncherState.active
            color: "transparent"

            property string query: ""
            property ListModel results: ListModel {}
            property int currentIndex: 0

            function rebuild(filter: string): void {
                const idx = Apps.search(filter);
                win.results.clear();
                for (const i of idx)
                    win.results.append({ rowIndex: i });
                win.currentIndex = 0;
            }

            function launchCurrent(): void {
                if (win.results.count === 0)
                    return;
                const row = win.results.get(win.currentIndex);
                if (row) {
                    Apps.launch(row.rowIndex);
                    LauncherState.active = false;
                }
            }

            Connections {
                target: LauncherState
                function onActiveChanged(): void {
                    if (LauncherState.active) {
                        input.text = "";
                        input.focus = true;
                    } else {
                        input.focus = false;
                    }
                }
            }

            // Transparent backdrop closes the launcher on outside click.
            MouseArea {
                anchors.fill: parent
                z: 0
                onClicked: LauncherState.active = false
            }

            Item {
                anchors.centerIn: parent
                width: Math.min(win.width * 0.5, 560)
                height: Math.min(win.height * 0.6, 520)

                AdaptiveRoundedRect {
                    anchors.fill: parent
                    tlRadius: Tokens.rounding.extraLarge
                    trRadius: Tokens.rounding.extraLarge
                    blRadius: Tokens.rounding.extraLarge
                    brRadius: Tokens.rounding.extraLarge
                    color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 0.97)

                    ColumnLayout {
                        id: panel
                        anchors.fill: parent
                        anchors.margins: Tokens.padding.large
                        spacing: Tokens.spacing.medium

                        // Search row
                        StyledRect {
                            id: searchBox
                            Layout.fillWidth: true
                            implicitHeight: 44
                            radius: Tokens.rounding.large
                            color: Colours.palette.m3surfaceContainerHighest

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Tokens.padding.medium
                                anchors.rightMargin: Tokens.padding.medium
                                spacing: Tokens.spacing.small

                                MaterialIcon {
                                    text: "search"
                                    color: Colours.palette.m3onSurfaceVariant
                                    fontStyle: Tokens.font.icon
                                }

                                Item {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    implicitHeight: 28

                                    StyledText {
                                        anchors.fill: parent
                                        text: root.emptyText
                                        font: Tokens.font.bodyLarge
                                        color: Colours.palette.m3onSurfaceVariant
                                        verticalAlignment: Text.AlignVCenter
                                        visible: input.text === ""
                                    }

                                    TextInput {
                                        id: input
                                        anchors.fill: parent
                                        color: Colours.palette.m3onSurface
                                        font: Tokens.font.bodyLarge
                                        clip: true
                                        selectByMouse: true
                                        verticalAlignment: Text.AlignVCenter

                                        onTextChanged: win.rebuild(text)
                                        Keys.onEscapePressed: LauncherState.active = false
                                        Keys.onReturnPressed: win.launchCurrent()
                                        Keys.onUpPressed: win.currentIndex = Math.max(0, win.currentIndex - 1)
                                        Keys.onDownPressed: win.currentIndex = Math.min(win.results.count - 1, win.currentIndex + 1)
                                    }
                                }
                            }
                        }

                        StyledText {
                            text: win.results.count === 0
                                  ? (input.text === "" ? "Type to search" : "No results")
                                  : ""
                            font: Tokens.font.bodySmall
                            color: Colours.palette.m3onSurfaceVariant
                            Layout.alignment: Qt.AlignHCenter
                        }

                        ListView {
                            id: list
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            spacing: Tokens.spacing.extraSmall
                            model: win.results
                            currentIndex: win.currentIndex
                            highlightMoveDuration: 140
                            highlightMoveVelocity: -1

                            delegate: LauncherItem {
                                index: model.index
                                readonly property int rowIndex: (win.results.get(index) ?? {}).rowIndex ?? -1

                                width: list.width
                                height: 52
                                highlighted: index === win.currentIndex

                                onClicked: {
                                    win.currentIndex = index;
                                    Apps.launch(rowIndex);
                                    LauncherState.active = false;
                                }
                            }
                        }
                    }
                }
            }

            component LauncherItem: ColumnLayout {
                id: li
                property int index: -1
                property bool highlighted: false
                property var onClicked: null

                spacing: Tokens.spacing.extraSmall

                StyledRect {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 52
                    radius: Tokens.rounding.large
                    color: li.highlighted
                           ? Colours.layer(Colours.palette.m3primary, 0.18)
                           : "transparent"

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: win.currentIndex = li.index
                        onClicked: li.onClicked()
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: Tokens.padding.small
                        anchors.rightMargin: Tokens.padding.small
                        spacing: Tokens.spacing.medium

                        Item {
                            width: 36
                            height: 36
                            Layout.alignment: Qt.AlignVCenter

                            Image {
                                anchors.fill: parent
                                anchors.margins: 6
                                source: Quickshell.iconPath(
                                    (win.results.get(li.index) || {}).icon ? win.results.get(li.index).icon : "application-x-executable",
                                    "application-x-executable")
                                sourceSize: Qt.size(36, 36)
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0

                            StyledText {
                                text: (win.results.get(li.index) || {}).name ?? ""
                                font: Tokens.font.bodyMedium
                                color: Colours.palette.m3onSurface
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            StyledText {
                                text: (win.results.get(li.index) || {}).comment ?? ""
                                font: Tokens.font.bodySmall
                                color: Colours.palette.m3onSurfaceVariant
                                elide: Text.ElideRight
                                visible: text !== ""
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }
        }
    }
}
