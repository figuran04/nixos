{ config, pkgs, ... }:

{
  # Supporting apps for the Quickshell desktop shell / Niri session.
  #
  # - wl-clipboard: wl-paste/wl-copy, handy on the command line.
  # - playerctl: MPRIS control used by the media-key binds in
  #   niri/binds.kdl.
  # - fuzzel: app launcher (Mod+D bind di niri/binds.kdl).
  # - brightnessctl: brightness keys (XF86MonBrightness bind).
  home.packages = with pkgs; [
    firefox
    tree
    wl-clipboard
    playerctl
    fuzzel
    brightnessctl
  ];
}
