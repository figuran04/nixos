# profiles/home/work.nix
# Profil HM mode kerja: tools development, produktivitas, tidak ada entertainment.
{ config, pkgs, ... }:
{
  # Dev tools
  home.packages = with pkgs; [
    # Editor
    neovim

    # Dev utilities
    jq           # JSON processor
    ripgrep      # grep cepat (rg)
    fd           # find modern
    bat          # cat dengan syntax highlight
    eza          # ls modern
    delta        # git diff highlighter
    lazygit      # TUI git
    bottom       # system monitor (btm)

    # Network tools
    curl
    wget
    httpie       # curl-like HTTP client yang ramah

    # Container / infra
    docker-compose
  ];

  # Git delta untuk diff yang lebih bagus
  programs.git = {
    delta.enable = true;
    extraConfig = {
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        light    = false;
      };
      merge.conflictstyle = "zdiff3";
    };
  };

  # Eza sebagai pengganti ls
  programs.eza = {
    enable        = true;
    enableBashIntegration = true;
    git           = true;
    icons         = "auto";
  };

  # Bat sebagai pengganti cat
  programs.bat = {
    enable = true;
    config.theme = "base16";
  };

  # SSH config untuk workflow kerja
  programs.ssh = {
    enable = true;
    extraConfig = ''
      # Aktifkan multiplexing untuk koneksi yang lebih cepat
      ControlMaster auto
      ControlPath   ~/.ssh/cm-%r@%h:%p
      ControlPersist 10m

      # Keep-alive agar koneksi tidak putus
      ServerAliveInterval 60
      ServerAliveCountMax 3
    '';
  };

  # XDG dirs untuk proyek kerja
  xdg.userDirs = {
    enable      = true;
    createDirectories = true;
    documents   = "${config.home.homeDirectory}/Documents";
    download    = "${config.home.homeDirectory}/Downloads";
    desktop     = "${config.home.homeDirectory}/Desktop";
  };
}
