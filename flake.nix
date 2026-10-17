{
  description = "NixOS + Niri + Home Manager — multi-host multi-profile";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, nix-colors, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    # mkHost: builder fleksibel, host hanya perlu menyebutkan profil yang dipakai.
    # Args:
    #   hardwareConfig  - path ke hardware-*.nix host ini
    #   nixosProfiles   - list modul profil NixOS yang diaktifkan
    #   homeProfiles    - list modul profil Home Manager yang diaktifkan
    #   extraModules    - list modul NixOS tambahan (opsional, default [])
    mkHost = {
      hardwareConfig,
      nixosProfiles ? [],
      homeProfiles  ? [],
      extraModules  ? [],
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          hardwareConfig
          ./modules/nixos/nix.nix    # selalu aktif: daemon nix
          ./modules/nixos/boot.nix   # selalu aktif: bootloader
          ./modules/nixos/users.nix  # selalu aktif: user figuran04
        ]
        ++ nixosProfiles
        ++ extraModules
        ++ [
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs    = true;
              useUserPackages  = true;
              extraSpecialArgs = { inherit inputs; };
              # home config dimuat dari host masing-masing
              users.figuran04  = { imports = homeProfiles; };
            };
          }
        ];
      };
  in
  {
    nixosConfigurations = {
      # ── hp ─────────────────────────────────────────────────────────
      # Laptop utama: desktop penuh (niri + audio + bluetooth).
      hp = mkHost {
        hardwareConfig = ./hardware-configuration.nix;
        nixosProfiles  = [
          ./profiles/nixos/base.nix
          ./profiles/nixos/desktop.nix
        ];
        homeProfiles = [
          ./profiles/home/base.nix
          ./profiles/home/desktop.nix
          ./hosts/hp/home.nix       # tweak spesifik host hp
        ];
        extraModules = [ ./hosts/hp/default.nix ];
      };

      # ── work ───────────────────────────────────────────────────────
      # Mode kerja: desktop + tools produktivitas, tanpa gaming/entertainment.
      work = mkHost {
        hardwareConfig = ./hardware-configuration.nix;  # ganti ke hardware kerja
        nixosProfiles  = [
          ./profiles/nixos/base.nix
          ./profiles/nixos/desktop.nix
          ./profiles/nixos/work.nix
        ];
        homeProfiles = [
          ./profiles/home/base.nix
          ./profiles/home/desktop.nix
          ./profiles/home/work.nix
          ./hosts/work/home.nix
        ];
        extraModules = [ ./hosts/work/default.nix ];
      };

      # ── anon ───────────────────────────────────────────────────────
      # Mode anonymous: Tor, MAC spoofing, firewall ketat, no history.
      anon = mkHost {
        hardwareConfig = ./hardware-configuration.nix;  # dipakai di device apa pun
        nixosProfiles  = [
          ./profiles/nixos/base.nix
          ./profiles/nixos/desktop.nix
          ./profiles/nixos/anonymous.nix
        ];
        homeProfiles = [
          ./profiles/home/base.nix
          ./profiles/home/desktop.nix
          ./profiles/home/anonymous.nix
          ./hosts/anon/home.nix
        ];
        extraModules = [ ./hosts/anon/default.nix ];
      };

      # ── default ────────────────────────────────────────────────────
      # Generik (untuk `nixos-install --flake .#default`): base + desktop.
      default = mkHost {
        hardwareConfig = ./hardware-configuration.nix;
        nixosProfiles  = [
          ./profiles/nixos/base.nix
          ./profiles/nixos/desktop.nix
        ];
        homeProfiles = [
          ./profiles/home/base.nix
          ./profiles/home/desktop.nix
        ];
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      name = "nixri-dev";
      packages = with pkgs; [ nixd nixfmt-rfc-style nil git ];
      shellHook = ''
        echo "🔧 nixri dev shell — nixd + nixfmt tersedia"
      '';
    };
  };
}