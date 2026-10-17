# profiles/nixos/base.nix
# Profil minimum: semua host pakai ini.
# Berisi: network, hardware dasar, audio, paket sistem.
{ pkgs, ... }:
{
  imports = [
    ../../modules/nixos/network.nix
    ../../modules/nixos/hardware.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/packages.nix
  ];

  time.timeZone = "Asia/Jakarta";

  # Lokalisasi
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font   = "Lat2-Terminus16";
    keyMap = "us";
  };
}
