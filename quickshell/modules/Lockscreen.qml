import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Pam
import "../components"
import "../services"

WlSessionLock {
    id: lock

    IpcHandler {
        target: "lockscreen"
        function lock() { lock.locked = true }
        function unlock() { lock.locked = false }
        function isLocked(): bool { return lock.locked }
    }

    // Password buffer + authentication state.
    property string buffer: ""
    property string state: ""

    function handleKey(event: var): void {
        if (pam.active || lock.state === "max")
            return;

        if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
            pam.start();
        } else if (event.key === Qt.Key_Backspace) {
            if (event.modifiers & Qt.ControlModifier)
                lock.buffer = "";
            else
                lock.buffer = lock.buffer.slice(0, -1);
        } else if (event.text && event.text.charCodeAt(0) >= 32) {
            lock.buffer += event.text;
        }
    }

    function resetState(): void {
        lock.buffer = "";
        lock.state = "";
    }

    Timer {
        id: stateReset
        interval: 4000
        onTriggered: {
            if (lock.state !== "max")
                lock.state = "";
        }
    }

    PamContext {
        id: pam

        config: "passwd"
        configDirectory: Quickshell.shellDir + "/assets/pam.d"

        onResponseRequiredChanged: {
            if (pam.responseRequired) {
                pam.respond(lock.buffer);
                lock.buffer = "";
            }
        }

        onCompleted: res => {
            if (res === PamResult.Success) {
                lock.locked = false;
            } else if (res === PamResult.Failed) {
                lock.state = "fail";
            } else if (res === PamResult.Error) {
                lock.state = "error";
            } else if (res === PamResult.MaxTries) {
                lock.state = "max";
            }
            stateReset.restart();
        }
    }

    Connections {
        target: lock

        function onSecureChanged(): void {
            if (lock.secure)
                lock.resetState();
        }
    }

    WlSessionLockSurface {
        Rectangle {
            anchors.fill: parent
            color: Colours.layer(Colours.palette.m3surfaceContainerLowest, 0.9)
        }

        StyledRect {
            id: inputArea

            anchors.centerIn: parent
            radius: Tokens.rounding.extraLarge
            color: Colours.palette.m3surfaceContainerHigh
            implicitWidth: 320
            implicitHeight: card.implicitHeight + Tokens.padding.large * 2

            focus: true
            onActiveFocusChanged: {
                if (!activeFocus)
                    forceActiveFocus();
            }
            Keys.onPressed: event => lock.handleKey(event)

            ColumnLayout {
                id: card

                anchors.fill: parent
                anchors.margins: Tokens.padding.large
                spacing: Tokens.spacing.medium

                MaterialIcon {
                    Layout.alignment: Qt.AlignHCenter
                    text: "lock"
                    color: Colours.palette.m3primary
                    fontStyle: Tokens.font.iconLarge
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: Time.time
                    font: Tokens.font.titleLarge
                    color: Colours.palette.m3onSurface
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: Time.date
                    font: Tokens.font.bodyLarge
                    color: Colours.palette.m3onSurfaceVariant
                }

                StyledRect {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: Tokens.spacing.small
                    implicitWidth: 200
                    implicitHeight: 40
                    radius: Tokens.rounding.full
                    color: Colours.palette.m3surfaceContainerHighest

                    StyledText {
                        anchors.centerIn: parent
                        text: lock.buffer ? "●".repeat(Math.max(1, lock.buffer.length)) : "Enter your password"
                        color: lock.buffer ? Colours.palette.m3onSurface : Colours.palette.m3onSurfaceVariant
                        font: lock.buffer ? Tokens.font.bodyMedium : Tokens.font.bodySmall
                    }
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: Tokens.spacing.small
                    visible: lock.state !== ""
                    text: {
                        if (lock.state === "error")
                            return "Authentication error";
                        if (lock.state === "max")
                            return "Maximum attempts reached";
                        if (lock.state === "fail")
                            return "Incorrect password. Try again.";
                        return "";
                    }
                    color: Colours.palette.m3error
                    font: Tokens.font.bodyMedium
                }

                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: Tokens.spacing.small
                    text: "Press Enter to unlock"
                    font: Tokens.font.bodySmall
                    color: Colours.palette.m3onSurfaceVariant
                }
            }
        }
    }
}
