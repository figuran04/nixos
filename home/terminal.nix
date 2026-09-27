{ config, pkgs, ... }:

{
  # Alacritty dipakai sebagai terminal default (lihat binds.kdl),
  # font-nya "Geist Mono". Foot sisa sebagai cadangan.
  programs.alacritty = {
    enable = true;
    settings.font = {
      normal = {
        family = "Geist Mono";
        style = "Regular";
      };
      bold = {
        family = "Geist Mono";
        style = "Bold";
      };
      italic = {
        family = "Geist Mono";
        style = "Italic";
      };
      size = 11;
    };
  };

  home.packages = with pkgs; [
    foot
  ];
}
