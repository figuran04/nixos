# modules/nixos/network.nix
# Jaringan: NetworkManager, firewall, SSH, hostname.
{ ... }:
{
  networking = {
    hostName = "hp";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  time.timeZone = "Asia/Jakarta";

  services.openssh = {
    enable = true;
    settings = {
      # Nonaktifkan password auth — gunakan SSH key.
      # Aktifkan setelah SSH key sudah terpasang di mesin.
      # PasswordAuthentication = false;
      X11Forwarding = false;
    };
  };
}
