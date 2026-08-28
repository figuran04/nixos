{ config, pkgs, ... }:

{
  xdg.configFile."niri/config.kdl".text = ''
    input {
      keyboard {
        xkb {
          layout "us"
        }
      }
    }

    layout {
      gaps 10
      center-focused-column "never"
    }

    prefer-no-csd

    binds {
      Mod+Return { spawn "alacritty"; }
      Mod+D { spawn "fuzzel"; }
      Mod+Q { close-window; }
      Mod+M { quit; }
    }
  '';
}
