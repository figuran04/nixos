{
  description = "NixOS + Niri + Home Manager";
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Noctalia v5 desktop shell. Pin the "cachix" branch so we always track
    # a commit with pre-built binaries on noctalia.cachix.org.
    # NOTE: no `nixpkgs.follows` here — overriding inputs changes the
    # derivation hash and causes cache misses.
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      # Builder dasar host: cukup ganti file hardware config.
      mkHost = hardwareConfig:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            hardwareConfig
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.figuran04 = import ./home.nix;
                extraSpecialArgs = {
                  inherit inputs;
                };
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        # Mesin "default" = device apa pun; pakai hardware-configuration.nix
        # hasil `nixos-generate-config` di mesin tersebut (lihat README).
        default = mkHost ./hardware-configuration.nix;
        # "hp" = skenario test VirtualBox (hardware-hp.nix), bukan mesin asli.
        hp = mkHost ./hardware-hp.nix;
      };
    };
}