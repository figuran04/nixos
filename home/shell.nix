{ config, pkgs, ... }:

{
  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
    };
  };
}
