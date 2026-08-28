{ config, pkgs, ... }:
{
  home.username = "figuran04";
  home.homeDirectory = "/home/figuran04";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    fuzzel
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, Return, exec, alacritty"
        "$mod, D, exec, fuzzel"
        "$mod, Q, killactive"
        "$mod, M, exit"
      ];
    };
  };
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec start-hyprland
      fi
    ''
  };
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "figuran04";
        email = "147382029+figuran04@users.noreply.github.com";
      };
    };
  };
  programs.home-manager.enable = true;
}                                                                                                                                                                                                                 