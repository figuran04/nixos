{ config, pkgs, lib, ... }:
let
  extraQtMods = [
    pkgs.qt6.qtimageformats
    pkgs.qt6.qtmultimedia
    pkgs.qt6.qt5compat
  ];

  quickshellPkg = pkgs.runCommand "quickshell-wrapped" {
    nativeBuildInputs = [ pkgs.makeWrapper ];
  } ''
    mkdir -p $out/bin
    makeWrapper ${pkgs.quickshell}/bin/quickshell $out/bin/quickshell \
      --prefix QML2_IMPORT_PATH : ${lib.makeSearchPathOutput "out" "lib/qt6/qml" extraQtMods} \
      --prefix QT_PLUGIN_PATH : ${lib.makeSearchPathOutput "out" "lib/qt6/plugins" extraQtMods}
  '';
in
{
  home.packages = [ quickshellPkg ];

  xdg.configFile."quickshell" = {
    source = ../quickshell;
    recursive = true;
  };
}
