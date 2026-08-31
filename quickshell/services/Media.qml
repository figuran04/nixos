pragma Singleton

import Quickshell
import Quickshell.Services.Mpris

Singleton {
    id: root

    readonly property MprisPlayer player: Mpris.players.length > 0 ? (Mpris.players[0] || null) : null
    readonly property bool playing: root.player != null && root.player.isPlaying

    function toggle() {
        const p = root.player;
        if (p) p.togglePlaying();
    }
}
