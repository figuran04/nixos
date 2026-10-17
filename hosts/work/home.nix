# hosts/work/home.nix
# HM overrides khusus host work.
{ pkgs, ... }:
{
  # colorScheme ikut yang sudah didefinisikan di profiles/home/base.nix

  home.packages = with pkgs; [
    # Tools tambahan yang hanya untuk mesin kerja
    remmina       # remote desktop (RDP/VNC)
    wireshark     # network analysis
  ];
}
