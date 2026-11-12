{...}: {
  imports = [
    ./boot.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./overlays.nix
    ./packages.nix
    ./programs.nix
    ./update.nix
    ./users.nix
  ];
}
