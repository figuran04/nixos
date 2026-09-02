{ config, pkgs, ... }:

{
  # Supporting apps for the Noctalia desktop shell.
  #
  # - wl-clipboard: wl-paste/wl-copy, used by Noctalia's clipboard history
  #   and handy on the command line.
  # - playerctl: MPRIS control used by the media-key binds in
  #   niri/binds.kdl.
  home.packages = with pkgs; [
    tree
    wl-clipboard
    playerctl
  ];
}
