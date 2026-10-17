{
  config,
  pkgs,
  ...
}:
{
  # Quickshell desktop shell (bar atas). Dijalankan dari niri startup,
  # jadi service systemd-nya dimatikan agar tidak dobel.
  programs.quickshell = {
    enable = true;
    systemd.enable = false;
  };

  # Quickshell memuat ~/.config/quickshell/shell.qml (lihat quickshell/shell.qml).
  xdg.configFile."quickshell/shell.qml".source = ../quickshell/shell.qml;
}
