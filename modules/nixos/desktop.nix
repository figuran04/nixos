# modules/nixos/desktop.nix
# Desktop environment: Niri WM, greetd greeter, XDG portals, dconf.
{ config, pkgs, ... }:
{
  # Niri — Wayland compositor scrollable tiling.
  programs.niri.enable = true;

  # Greeter: langsung jalankan niri-session tanpa display manager berbasis X.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "figuran04";
      };
    };
  };

  # Matikan Xorg — kita full Wayland.
  services.xserver.enable = false;

  # XDG Desktop Portal — diperlukan untuk file picker, screen share, dll.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    # Implementasi portal untuk Wayland compositors non-GNOME/KDE.
    config.common.default = "*";
  };

  # dconf/GSettings diperlukan GTK apps di lingkungan non-GNOME.
  programs.dconf.enable = true;
}
