{ config, pkgs, ... }:

{
  # Supporting apps for the Quickshell desktop shell.
  #
  # - wl-clipboard: wl-paste/wl-copy, required by the clipboard-history
  #   service (services/Clipboard.qml). Without it the Clipboard popout
  #   can neither watch the clipboard nor copy entries back.
  # - playerctl: MPRIS control used by the media-key binds in
  #   niri/binds.kdl (and handy to inspect players for the Dashboard
  #   media section).
  #
  # System Tray, Launcher, ActiveWindow, and Dashboard read /proc, D-Bus
  # and the .desktop index directly via Quickshell, so they need no
  # external program.
  home.packages = with pkgs; [
    fuzzel
    tree
    wl-clipboard
    playerctl
  ];
}
