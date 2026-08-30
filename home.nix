{ config, pkgs, ... }:

{
  home.username = "figuran04";
  home.homeDirectory = "/home/figuran04";
  home.stateVersion = "26.05";

  imports = [
    ./home/niri.nix
    ./home/terminal.nix
    ./home/shell.nix
    ./home/git.nix
    ./home/apps.nix
    ./home/quickshell.nix
  ];

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.material-symbols
    pkgs.noto-fonts
    pkgs.jetbrains-mono
  ];
}
