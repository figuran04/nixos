# profiles/nixos/desktop.nix
# Profil desktop penuh: Niri WM, greetd, XDG portals, dconf.
{ ... }:
{
  imports = [
    ../../modules/nixos/desktop.nix
  ];
}
