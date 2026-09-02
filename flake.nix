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
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.hp = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./hardware-configuration.nix
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
  };
}