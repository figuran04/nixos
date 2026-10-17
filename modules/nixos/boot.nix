# modules/nixos/boot.nix
# Bootloader: systemd-boot + EFI.
{ ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Batasi entry bootloader agar tidak penuh dengan generasi lama.
  boot.loader.systemd-boot.configurationLimit = 10;
}
