pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNodeAudio sinkAudio: root.sink ? root.sink.audio : null
    readonly property real volume: root.sinkAudio ? root.sinkAudio.volume : 0
    readonly property bool muted: root.sinkAudio ? root.sinkAudio.muted : false

    function setVolume(vol) {
        const n = root.sinkAudio;
        if (n) n.volume = Math.max(0, Math.min(1, vol));
    }

    function setMuted(m) {
        const n = root.sinkAudio;
        if (n) n.muted = m;
    }

    function toggleMute() {
        const n = root.sinkAudio;
        if (n) n.muted = !n.muted;
    }
}
