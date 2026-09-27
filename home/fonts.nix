{
  config,
  pkgs,
  ...
}:
{
  # Font: pakai familia Geist.
  home.packages = with pkgs; [
    geist-font
    nerd-fonts.geist-mono
    material-symbols
    noto-fonts
    jetbrains-mono
  ];

  # Aktifkan manajemen fontconfig di level Home Manager
  fonts.fontconfig.enable = true;

  # Buat rule custom fontconfig via XDG config
  xdg.configFile."fontconfig/conf.d/10-geist-mono-fallback.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <match target="pattern">
        <test qual="any" name="family">
          <string>Geist Mono</string>
        </test>
        <edit name="family" mode="append" binding="strong">
          <string>GeistMono Nerd Font Propo</string>
        </edit>
      </match>
    </fontconfig>
  '';
}