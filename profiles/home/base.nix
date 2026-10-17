# profiles/home/base.nix
# Profil HM minimum: shell, direnv, git, starship, fonts.
{ config, pkgs, inputs, ... }:
{
  home.username     = "figuran04";
  home.homeDirectory = "/home/figuran04";
  home.stateVersion = "26.05";

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ../../home/shell.nix
    ../../home/git.nix
    ../../home/fonts.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;

  programs.home-manager.enable = true;
}
