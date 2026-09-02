{ config, lib, pkgs, inputs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "hp";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Jakarta";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 2d";
  };
  hardware.graphics = {
    enable32Bit = true;
  };
  services.pipewire = {
    enable = true;
    audio.enable = true;
  };
  security.rtkit.enable = true;
  services.upower.enable = true;
  hardware.bluetooth.enable = true;
  # Noctalia's power-profile feature needs a power profile service.
  services.power-profiles-daemon.enable = true;

  hardware.cpu.intel.updateMicrocode = true;
  hardware.cpu.amd.updateMicrocode = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.niri = {
    enable = true;
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = "figuran04";
      };
    };
  };
  services.xserver.enable = false;
  services.openssh = {
    enable = true;
    # settings.PasswordAuthentication = false;
  };
  networking.firewall.allowedTCPPorts = [
    22
  ];
  users.users.figuran04 = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    xwayland-satellite
  ];
  environment.defaultPackages = [];
  documentation.enable = false;
  system.stateVersion = "26.05";
}