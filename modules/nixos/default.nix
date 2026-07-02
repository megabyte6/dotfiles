{inputs, ...}: {
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.nix-index-database.nixosModules.default

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
  ];
}
