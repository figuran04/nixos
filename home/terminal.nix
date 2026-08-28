{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    alacritty
    foot
  ];
}
