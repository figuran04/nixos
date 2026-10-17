# modules/nixos/hardware.nix
# Hardware umum: graphics, bluetooth, power, microcode CPU.
{ pkgs, ... }:
{
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true; # OpenGL 32-bit (Wine / Steam)
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Update microcode untuk keamanan — aktifkan sesuai CPU yang ada.
    cpu.intel.updateMicrocode = true;
    cpu.amd.updateMicrocode = true;
  };

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.blueman.enable = true; # GUI bluetooth manager
}
