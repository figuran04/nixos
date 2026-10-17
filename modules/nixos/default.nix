# modules/nixos/default.nix
# Root modul NixOS — import semua sub-modul dari sini.
# Tambahkan modul baru di sini agar otomatis terbawa.
{ ... }:
{
  imports = [
    ./nix.nix
    ./boot.nix
    ./network.nix
    ./audio.nix
    ./hardware.nix
    ./desktop.nix
    ./users.nix
    ./packages.nix
  ];
}
