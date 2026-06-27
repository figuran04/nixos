{ config, pkgs, ... }: {
  home.username = "figuran04";
  home.homeDirectory = "/home/figuran04";
  home.stateVersion = "24.11"; 
  home.packages = with pkgs; [
    foot
    fuzzel
  ];

  programs.git = {
    enable = true;
    userName = "figuran04";
    userEmail = "147382029+figuran04@users.noreply.github.com";
  };

  programs.home-manager.enable = true;
}
