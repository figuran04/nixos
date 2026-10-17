{ config, pkgs, ... }:

let
  # Ambil 16 warna dari colorScheme yang aktif di home.nix.
  c = config.colorScheme.palette;
  hex = color: "#${color}"; # helper: tambah prefix "#"
in
{
  # Alacritty dipakai sebagai terminal default (lihat binds.kdl),
  # font-nya "Geist Mono". Foot sisa sebagai cadangan.
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal = {
          family = "Geist Mono";
          style = "Regular";
        };
        bold = {
          family = "Geist Mono";
          style = "Bold";
        };
        italic = {
          family = "Geist Mono";
          style = "Italic";
        };
        size = 11;
      };

      # Warna ikut colorScheme — tidak perlu edit manual saat ganti tema.
      colors = {
        primary = {
          background = hex c.base00;
          foreground = hex c.base05;
        };
        cursor = {
          text = hex c.base00;
          cursor = hex c.base05;
        };
        normal = {
          black   = hex c.base00;
          red     = hex c.base08;
          green   = hex c.base0B;
          yellow  = hex c.base0A;
          blue    = hex c.base0D;
          magenta = hex c.base0E;
          cyan    = hex c.base0C;
          white   = hex c.base05;
        };
        bright = {
          black   = hex c.base03;
          red     = hex c.base08;
          green   = hex c.base0B;
          yellow  = hex c.base0A;
          blue    = hex c.base0D;
          magenta = hex c.base0E;
          cyan    = hex c.base0C;
          white   = hex c.base07;
        };
      };

      window = {
        padding = { x = 8; y = 8; };
        opacity = 0.95;
      };
    };
  };

  home.packages = with pkgs; [
    foot # terminal cadangan
  ];
}
