# profiles/home/desktop.nix
# Profil HM desktop: GTK theming, terminal + colorScheme, apps desktop, quickshell.
{ ... }:
{
  imports = [
    ../../home/niri.nix
    ../../home/terminal.nix
    ../../home/gtk.nix
    ../../home/apps.nix
    ../../home/quickshell.nix
  ];
}
