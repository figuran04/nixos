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
  programs.hyprland = {
    enable = true;
    xwayland = true;
    # package = pkgs.hyprland;
    # portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
  virtualisation.virtualbox.guest.enable = true;
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
  #       user = "greeter";
  #     };
  #   };
  # };
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
    packages = with pkgs; [
      tree
    ];
  };
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    foot
    alacritty
  ];
  environment.defaultPackages = [];
  documentation.enable = false;
  system.stateVersion = "26.05";
}