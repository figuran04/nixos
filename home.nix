# home.nix (UPDATE untuk backward compat dengan default config)
{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./home/niri.nix
    ./home/terminal.nix
    ./home/shell.nix
    ./home/git.nix
    ./home/apps.nix
    ./home/quickshell.nix
    ./home/gtk.nix
    ./home/fonts.nix
  ];

  home.username      = "figuran04";
  home.homeDirectory = "/home/figuran04";
  home.stateVersion  = "26.05";

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  programs.home-manager.enable = true;
}
