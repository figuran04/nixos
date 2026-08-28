{ config, pkgs, ... }:

{
  xdg.configFile."niri/config.kdl".source = ../niri/config.kdl;
  xdg.configFile."niri/binds.kdl".source = ../niri/binds.kdl;
  xdg.configFile."niri/input.kdl".source = ../niri/input.kdl;
  xdg.configFile."niri/startup.kdl".source = ../niri/startup.kdl;
}
