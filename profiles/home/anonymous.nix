# profiles/home/anonymous.nix
# Profil HM anonymous: browser privasi, tidak ada history, env bersih.
{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    torbrowser     # browser sudah di-hardening
  ];

  # Bash tanpa history
  programs.bash.historySize    = 0;
  programs.bash.historyFileSize = 0;
  programs.bash.bashrcExtra = ''
    # Jangan simpan history sama sekali
    unset HISTFILE
    export HISTSIZE=0
  '';

  # Proxy environment variables → traffic lewat Tor
  home.sessionVariables = {
    http_proxy  = "http://127.0.0.1:8118";   # Privoxy
    https_proxy = "http://127.0.0.1:8118";
    HTTP_PROXY  = "http://127.0.0.1:8118";
    HTTPS_PROXY = "http://127.0.0.1:8118";
    no_proxy    = "localhost,127.0.0.1";
  };

  # Nonaktifkan XDG user dirs tracking (tidak buat Documents, Videos, dll.)
  xdg.userDirs.enable = false;
}
