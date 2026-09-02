{
  config,
  inputs,
  pkgs,
  ...
}:
{
  # Noctalia v5 — konfigurasi shell (diadaptasi dari template v4: bar atas,
  # layout widget, tema dark Catppuccin, wallpaper, shortcut Control Center).
  # Keys mengikuti schema TOML v5 (snake_case), di-set lewat module
  # inputs.noctalia.homeModules.default.
  programs.noctalia = {
    enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        fill_mode = "crop";
        transition = [ "fade" ];
        transition_duration = 1200;
        directory = "/home/figuran04/Pictures/wallpapers";
        default.path = "/home/figuran04/Pictures/wallpaper.png";
      };

      shell = {
        telemetry_enabled = false;
        setup_wizard_enabled = true;
      };

      bar = {
        order = [ "main" ];
        default = {
          position = "top";
          thickness = 36;
          background_opacity = 0.93;
          border_width = 0;
          radius = 12;
          margin_ends = 4;
          margin_edge = 4;
          capsule = true;
          capsule_fill = "surface_variant";
          capsule_thickness = 0.76;
          capsule_opacity = 1.0;
          start = [ "clock" "sysmon" "media" ];
          center = [ "workspaces" ];
          end = [ "tray" "notifications" "brightness" "battery" "volume" "bluetooth" "control-center" ];
        };
      };

      widget = {
        clock = {
          format = "{:%-I:%M %p}";
        };
      };

      control_center = {
        shortcuts = [
          { type = "wifi"; }
          { type = "bluetooth"; }
          { type = "wallpaper"; }
          { type = "power_profile"; }
          { type = "notification"; }
          { type = "nightlight"; }
        ];
      };

      osd = {
        position = "top_right";
        background_opacity = 0.97;
        border = true;
      };

      audio = {
        enable_sounds = false;
      };

      brightness = {
        minimum_brightness = 0.05;
      };
    };
  };
}