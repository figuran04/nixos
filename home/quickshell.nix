{ config, pkgs, inputs, ... }:
let
  quickshellPkg = inputs.quickshell.packages.${pkgs.system}.default.withModules [
    pkgs.qtsvg
    pkgs.qtimageformats
    pkgs.qtmultimedia
    pkgs.qt5compat
  ];
in
{
  home.packages = [ quickshellPkg ];

  xdg.configFile."quickshell" = {
    source = ../quickshell;
    recursive = true;
  };
}
