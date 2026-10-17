# modules/nixos/nix.nix
# Pengaturan daemon Nix: flakes, store optimisation, garbage collection.
{ ... }:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    # Izinkan user wheel menggunakan nix tanpa sudo.
    trusted-users = [ "root" "@wheel" ];
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d"; # naik dari 2d → rollback lebih aman
  };
}
