pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property real volume: sink != null && sink.audio != null ? sink.audio.volume : 0
  readonly property bool muted: sink != null && sink.audio != null ? sink.audio.muted : false

  function setVolume(v) {
    if (sink != null && sink.audio != null)
      sink.audio.volume = Math.max(0, Math.min(1.5, v));
  }

  function toggleMute() {
    if (sink != null && sink.audio != null)
      sink.audio.muted = !sink.audio.muted;
  }
}
