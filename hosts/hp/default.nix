# hosts/hp/default.nix
# Konfigurasi spesifik host "hp" (laptop HP).
# Profil dipilih di flake.nix — file ini hanya tweak host-specific.
{ ... }:
{
  networking.hostName = "hp";

  # Tweak spesifik laptop HP
  services.thermald.enable  = true;  # thermal management Intel
  powerManagement.enable    = true;
  powerManagement.powertop.enable = true; # auto-tune power saat battery
}
