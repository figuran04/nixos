# profiles/nixos/work.nix
# Profil mode kerja: SSH hardened, printing, tanpa Bluetooth LE scanning.
{ pkgs, ... }:
{
  # SSH lebih ketat untuk environment kerja
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin        = "no";
      KbdInteractiveAuthentication = false;
    };
  };

  # Printing (untuk environment kantor)
  services.printing.enable = true;
  services.avahi = {
    enable   = true;
    nssmdns4 = true;  # mDNS untuk network printer discovery
    openFirewall = true;
  };

  # Firewall lebih strict untuk jaringan kerja
  networking.firewall = {
    enable = true;
    allowedTCPPorts    = [ 22 ];
    allowedUDPPorts    = [];
    logReversePathDrops = true;
  };

  # Paket tambahan level sistem untuk kerja
  environment.systemPackages = with pkgs; [
    openssl
    curl
  ];
}
