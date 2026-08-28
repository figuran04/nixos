{ config, lib, pkgs, ... }:
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
    dates = "weekly";
    options = "--delete-older-than 2d";
  };
  hardware.graphics = {
    enable32Bit = true;
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
systemd.user.services.niri.enableDefaultPath = false;
  services.xserver.enable = false;
  services.openssh.enable = true;
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