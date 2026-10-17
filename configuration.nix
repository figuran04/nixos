# configuration.nix
# Entry point konfigurasi NixOS — hanya import modul.
# Logika nyata ada di modules/nixos/*.nix
{ ... }:
{
  imports = [
    ./modules/nixos
  ];
}