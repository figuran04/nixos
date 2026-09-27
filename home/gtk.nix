{
  config,
  pkgs,
  ...
}:

{
  # GTK theming supaya aplikasi GTK (Firefox, dsb.) tampil konsisten &
  # match tema gelap Noctalia (M3/libadwaita look via adw-gtk3).
  home.packages = with pkgs; [
    adw-gtk3            # tema libadwaita untuk aplikasi GTK3
    papirus-icon-theme  # set ikon lengkap
    bibata-cursors      # set kursor Wayland
  ];

  gtk = {
    enable = true;

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    font = {
      name = "Geist Mono";
      size = 11;
    };

    # Diubah dari extraConfig menjadi gtk3.extraConfig
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Kursor juga dipakai toolkit lain / niri (bukan hanya GTK).
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  # GTK4 apps membaca settings-nya sendiri (gsettings/dconf), dorong dark.
  xdg.configFile."gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-theme-name=adw-gtk3-dark
    gtk-icon-theme-name=Papirus-Dark
    gtk-cursor-theme-name=Bibata-Modern-Ice
    gtk-font-name=Geist Mono 11
  '';
}