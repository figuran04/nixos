{ config, pkgs, ... }:

{
  # ── Bash ─────────────────────────────────────────────────────────────
  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l  = "ls -CF";

      # Shortcuts NixOS / Flake
      rebuild = "sudo nixos-rebuild switch --flake ~/nixri#hp";
      rebuild-test = "sudo nixos-rebuild test --flake ~/nixri#hp";
      hms = "home-manager switch --flake ~/nixri#figuran04@hp";
      nix-clean = "nix-collect-garbage -d && sudo nix-collect-garbage -d";
      nix-generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";

      # Utilitas umum
      grep = "grep --color=auto";
      ip   = "ip --color=auto";
    };

    # Tampilkan nama colorScheme aktif saat shell dibuka (opsional).
    bashrcExtra = ''
      # Tampilkan colorScheme aktif
      echo "🎨 Theme: ${config.colorScheme.name}"
    '';
  };

  # ── Direnv + Nix-Direnv ──────────────────────────────────────────────
  # Auto-load shell environment saat masuk ke folder project.
  # Taruh `.envrc` di project: `echo "use flake" > .envrc && direnv allow`
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # cache store path → masuk folder instan

    config = {
      global = {
        warn_timeout = "30s";
        hide_env_diff = true; # sembunyikan diff panjang saat load
      };
    };
  };

  # ── Starship prompt ──────────────────────────────────────────────────
  # Prompt minimal yang menampilkan Nix dev shell aktif.
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      format = "$nix_shell$directory$git_branch$git_status$character";

      nix_shell = {
        format  = "[$symbol$name]($style) ";
        symbol  = "❄️ ";
        style   = "bold blue";
        # Tampilkan nama flake/shell saat dalam `nix develop` / `nix-shell`
        impure_msg = "[impure]";
        pure_msg   = "[pure]";
      };

      directory = {
        truncation_length = 3;
        style = "bold cyan";
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        style  = "bold purple";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
      };
    };
  };
}
