# hosts/hp/home.nix
# HM overrides spesifik untuk host hp.
{ pkgs, ... }:
{
  # Paket tambahan khusus laptop hp (bukan di profil umum)
  home.packages = with pkgs; [
    obs-studio     # screen recording / streaming
    mpv            # media player
  ];
}
