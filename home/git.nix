{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "figuran04";
        email = "147382029+figuran04@users.noreply.github.com";
      };
    };
  };
}
