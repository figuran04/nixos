{
  config,
  pkgs,
  inputs,
  ...
}:

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
    ./home/noctalia.nix
    ./home/gtk.nix
    ./home/fonts.nix
    inputs.noctalia.homeModules.default
  ];

  programs.home-manager.enable = true;
}
