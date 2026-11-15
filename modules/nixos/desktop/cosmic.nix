{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  # The stable channel ships an old COSMIC. Take the NixOS modules and every
  # COSMIC package from nixpkgs-unstable instead, so they always match.
  cosmicModules = [
    "services/desktop-managers/cosmic.nix"
    "services/display-managers/cosmic-greeter.nix"
  ];
  isCosmicPackage = name:
    lib.hasPrefix "cosmic-" name || name == "xdg-desktop-portal-cosmic";
in {
  # Swap the stable modules for unstable's. These are loaded unconditionally
  # (imports can't depend on config) but do nothing unless enabled below.
  disabledModules = cosmicModules;
  imports = map (path: "${inputs.nixpkgs-unstable}/nixos/modules/${path}") cosmicModules;

  config = lib.mkIf (config.my.desktop.environment == "cosmic") {
    nixpkgs.overlays = [
      (_: prev:
        lib.filterAttrs (name: _: isCosmicPackage name)
        inputs.nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system})
    ];

    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;

    environment.cosmic.excludePackages = with pkgs; [
      # Ghostty is the terminal (packages.nix).
      cosmic-term
    ];

    environment.systemPackages = with pkgs; [
      # COSMIC has no disk usage analyzer. Native for the same reason as on
      # niri (niri.nix): the flatpak version does not work well.
      baobab
    ];
  };
}
