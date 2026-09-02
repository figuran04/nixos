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
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      wallpaper = {
        enabled = true;
        # Taruh gambar wallpaper di sini, atau pilih dari Settings Noctalia
        # (Wallpaper browser menyimpan pilihan GUI secara terpisah).
        default.path = "/home/figuran04/Pictures/wallpaper.png";
      };
    };
  };

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.material-symbols
    pkgs.noto-fonts
    pkgs.jetbrains-mono
  ];
}
