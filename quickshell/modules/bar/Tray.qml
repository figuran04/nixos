import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import "../../components"
import "../../services"

StyledRect {
    id: root

    color: Colours.palette.m3surfaceContainer
    radius: Tokens.rounding.full
    implicitWidth: Tokens.sizes.bar.innerWidth
    implicitHeight: col.visible ? col.implicitHeight + Tokens.padding.medium * 2 : 0

    readonly property int entry: Tokens.sizes.bar.innerWidth - Tokens.padding.medium * 2

    ColumnLayout {
        id: col

        visible: SystemTray.items.count > 0
        anchors.fill: parent
        anchors.margins: Tokens.padding.medium
        spacing: Tokens.spacing.medium

        Repeater {
            model: SystemTray.items

            Item {
                required property SystemTrayItem modelData

                Layout.alignment: Qt.AlignHCenter
                implicitWidth: root.entry
                implicitHeight: root.entry

                Image {
                    id: trayIcon
                    anchors.centerIn: parent
                    width: 18
                    height: 18
                    source: modelData.icon
                    sourceSize.width: 18
                    sourceSize.height: 18
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: parent.opacity = 0.7
                    onExited: parent.opacity = 1
                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton)
                            modelData.activate();
                        else
                            modelData.secondaryActivate();
                    }
                }

                Behavior on opacity {
                    Anim { type: Anim.DefaultEffects }
                }
            }
        }
    }
}
