{
  pkgs,
  lib,
  ...
}:
# Waterfox tidak ada di nixpkgs, jadi di-derive dari tarball resmi
# (https://www.waterfox.com). Binary ditimpa ke dalam environment FHS
# (pola yang sama seperti google-chrome / firefox-bin) supaya semua
# dependency library terpenuhi tanpa menebak-nebak LD_LIBRARY_PATH.
let
  version = "6.7.1.1";

  src = pkgs.fetchurl {
    url = "https://cdn.waterfox.com/waterfox/releases/${version}/Linux_x86_64/waterfox-${version}.tar.bz2";
    sha512 = "sha512-5Q2JmJfy96s40LHrMT09c99ItPgwGKDanFI3XafcgbCSwcNk9NwzvWisHkjf37oeoLucbIQpCb6a7nqTSn4C4g==";
  };

  # 1. Ekstrak tarball (folder dalam arsip bernama waterfox-*).
  waterfox-bin = pkgs.stdenv.mkDerivation {
    pname = "waterfox-bin";
    inherit version src;
    phases = [ "unpackPhase" "installPhase" ];
    unpackPhase = ''
      mkdir -p "$TMPDIR/src"
      tar -xjf "$src" -C "$TMPDIR/src"
      cd "$TMPDIR/src"
    '';
    installPhase = ''
      wfdir=$(find . -maxdepth 1 -type d -name 'waterfox*' | head -n1)
      mkdir -p "$out/libexec"
      cp -r "$wfdir" "$out/libexec/waterfox"
      chmod +x "$out/libexec/waterfox/waterfox"
    '';
  };

  # 2. Bungkus dengan filesystem environment (semua lib browser di /usr/lib).
  waterfox-fhs = pkgs.buildFHSEnv {
    name = "waterfox-fhs";
    targetPkgs = pkgs: [
      pkgs.gtk3
      pkgs.glib
      pkgs.gdk-pixbuf
      pkgs.pango
      pkgs.cairo
      pkgs.fontconfig
      pkgs.freetype
      pkgs.libGL
      pkgs.dbus
      pkgs.dbus-glib
      pkgs.alsa-lib
      pkgs.pulseaudio
      pkgs.glib-networking
      pkgs.gsettings-desktop-schemas
      pkgs.xdg-utils
      pkgs.shared-mime-info
      pkgs.xorg.libX11
      pkgs.xorg.libXcomposite
      pkgs.xorg.libXdamage
      pkgs.xorg.libXext
      pkgs.xorg.libXfixes
      pkgs.xorg.libXrandr
      pkgs.xorg.libXrender
      pkgs.xorg.libXt
      pkgs.xorg.libXtst
      pkgs.xorg.libXScrnSaver
      pkgs.xorg.libxkbfile
    ];
    runScript = "${waterfox-bin}/libexec/waterfox/waterfox";
  };

  # 3. Icon untuk launcher.
  waterfox-icon = pkgs.runCommand "waterfox-icon" { } ''
    mkdir -p "$out/share/icons/hicolor/256x256/apps"
    cp "${waterfox-bin}/libexec/waterfox/browser/chrome/icons/default/default256.png" \
      "$out/share/icons/hicolor/256x256/apps/waterfox.png"
  '';

  # 4. Desktop entry supaya muncul di launcher Noctalia.
  waterfox-desktop = pkgs.makeDesktopItem {
    name = "waterfox";
    desktopName = "Waterfox";
    comment = "Waterfox web browser";
    exec = "waterfox %U";
    icon = "waterfox";
    terminal = false;
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeTypes = [
      "text/html"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
  };
in
{
  home.packages = [
    (pkgs.symlinkJoin {
      name = "waterfox-${version}";
      paths = [
        waterfox-fhs
        waterfox-icon
        waterfox-desktop
      ];
      meta = with lib; {
        description = "Waterfox web browser (pupuk FOSS dari Mozilla Firefox)";
        homepage = "https://www.waterfox.com";
        license = licenses.mpl20;
        platforms = platforms.linux;
      };
    })
  ];
}