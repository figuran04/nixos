# profiles/nixos/anonymous.nix
# Profil anonymous: Tor, MAC randomization, firewall ketat, no logs.
# Cocok untuk device asing atau sesi yang tidak ingin meninggalkan jejak.
{ pkgs, lib, ... }:
{
  # ── Tor ──────────────────────────────────────────────────────────
  services.tor = {
    enable = true;
    client = {
      enable = true;
      dns.enable = true;  # DNS lewat Tor
    };
  };

  # ── Privoxy: HTTP proxy lewat Tor ────────────────────────────────
  services.privoxy = {
    enable = true;
    settings = {
      forward-socks5   = "/ 127.0.0.1:9050 .";
      listen-address   = "127.0.0.1:8118";
    };
  };

  # ── MAC Address Randomization ─────────────────────────────────────
  networking.networkmanager.wifi.scanRandMacAddress = "always";

  # Override network module: tidak ada hostname yang bisa diidentifikasi
  networking.hostName     = "localhost";
  networking.hostId       = "deadbeef";

  # ── Firewall sangat ketat ─────────────────────────────────────────
  networking.firewall = {
    enable             = true;
    allowedTCPPorts    = [];  # tutup semua port masuk
    allowedUDPPorts    = [];
    logReversePathDrops = true;
    # Blokir semua outbound kecuali Tor
    extraCommands = ''
      # Izinkan outbound ke Tor relay (port 9001 & 9030)
      iptables -A OUTPUT -p tcp --dport 9001 -j ACCEPT
      iptables -A OUTPUT -p tcp --dport 9030 -j ACCEPT
    '';
  };

  # ── Nonaktifkan logging sistem ────────────────────────────────────
  services.journald.extraConfig = ''
    Storage=volatile
    RuntimeMaxUse=32M
  '';

  # ── Nonaktifkan fitur yang bisa bocorkan identitas ─────────────────
  services.avahi.enable        = false;
  services.printing.enable     = false;
  hardware.bluetooth.enable    = lib.mkForce false;

  # ── RAM-only tmp: bersih saat reboot ─────────────────────────────
  boot.tmp.useTmpfs    = true;
  boot.tmp.tmpfsSize   = "50%";

  environment.systemPackages = with pkgs; [
    tor
    torbrowser
  ];
}
