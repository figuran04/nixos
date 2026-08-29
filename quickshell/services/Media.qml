pragma Singleton
import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Singleton {
  readonly property MprisPlayer player: {
    for (let i = 0; i < Mpris.players.count; i++) {
      const p = Mpris.players.get(i);
      if (p.playbackState === MprisPlaybackState.Playing)
        return p;
    }
    return Mpris.players.count > 0 ? Mpris.players.get(0) : null;
  }
}
