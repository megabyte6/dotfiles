{inputs, ...}: {
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.nix-index-database.nixosModules.default
    inputs.binaryninja.nixosModules.binaryninja

    ./audio.nix
    ./biometrics.nix
    ./boot.nix
    ./desktop.nix
    ./hardware.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./overlays.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./update.nix
    ./users.nix
    ./virtualisation.nix

    ./ensc351.nix
  ];
}
