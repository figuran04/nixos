{ config, pkgs, ... }:

{
  home.username = "figuran04";
  home.homeDirectory = "/home/figuran04";
  home.stateVersion = "24.11";

  imports = [
    ./home/niri.nix
    ./home/terminal.nix
    ./home/shell.nix
    ./home/git.nix
    ./home/apps.nix
  ];

  programs.home-manager.enable = true;
}
