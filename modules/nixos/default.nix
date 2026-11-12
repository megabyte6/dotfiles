{inputs, ...}: {
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.nix-index-database.nixosModules.default
    inputs.binaryninja.nixosModules.binaryninja

    ./core
    ./desktop
    ./features
    ./hardware
    ./profiles
  ];
}
