# modules/nixos/packages.nix
# Paket sistem (bukan user) — minimal, sisanya lewat Home Manager.
{ pkgs, ... }:
{
  # Hanya paket yang benar-benar perlu di level sistem.
  # Paket per-user dikelola di home/*.nix via Home Manager.
  environment.systemPackages = with pkgs; [
    vim    # editor fallback saat HM belum terpasang
    wget   # download utility
    git    # diperlukan sistem (flake fetch, dll.)
    xwayland-satellite # Xwayland rootless untuk app X11 di Wayland
  ];

  # Hapus paket default NixOS yang tidak diperlukan (nano, perl, dll.)
  environment.defaultPackages = [ ];

  # Dokumentasi tidak diperlukan di server/WM-only system.
  documentation.enable = false;

  # stateVersion: JANGAN diubah setelah install pertama.
  system.stateVersion = "26.05";
}
