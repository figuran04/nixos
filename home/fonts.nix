{
  config,
  pkgs,
  ...
}:
{
  # Font: pakai famila Geist.
  # - "Geist Mono" (dari paket geist-font) = font biasa/utama.
  # - "GeistMono Nerd Font Propo" (dari paket nerd-fonts.geist-mono) =
  #   varian proporsional + glyph ikon (Nerd Fonts), dipakai untuk ikon.
  home.packages = with pkgs; [
    geist-font
    nerd-fonts.geist-mono
    material-symbols
    noto-fonts
    jetbrains-mono
  ];

  # Fallback: glyph yang tidak ada di "Geist Mono" (mis. ikon Nerd Font)
  # otomatis diambil dari varian Propo.
  fonts.fontconfig.localConf = ''
    <match target="pattern">
      <test qual="any" name="family">
        <string>Geist Mono</string>
      </test>
      <edit name="family" mode="append" binding="strong">
        <string>GeistMono Nerd Font Propo</string>
      </edit>
    </match>
  '';
}