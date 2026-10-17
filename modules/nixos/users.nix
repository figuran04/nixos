# modules/nixos/users.nix
# Definisi user sistem.
{ pkgs, ... }:
{
  users.users.figuran04 = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [
      "wheel"           # sudo
      "networkmanager"  # kelola koneksi NM tanpa sudo
      "audio"           # akses langsung audio device (fallback)
      "video"           # akses GPU / backlight
    ];
  };
}
