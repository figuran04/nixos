# hosts/work/default.nix
# Host mode kerja: hostname berbeda, Docker daemon.
{ pkgs, ... }:
{
  networking.hostName = "work";

  # Docker untuk development container
  virtualisation.docker = {
    enable           = true;
    autoPrune.enable = true;
  };

  # Pastikan user masuk grup docker
  users.users.figuran04.extraGroups = [ "docker" ];
}
