{
  config,
  lib,
  inputs,
  ...
}: let
  # The stable channel ships an old COSMIC. Take the NixOS modules and every
  # COSMIC package from nixpkgs-unstable instead, so they always match.
  unstableModules = "${inputs.nixpkgs-unstable}/nixos/modules/services";
  isCosmicPackage = name:
    lib.hasPrefix "cosmic-" name || name == "xdg-desktop-portal-cosmic";
in {
  # Swap the stable modules for unstable's. These are loaded unconditionally
  # (imports can't depend on config) but do nothing unless enabled below.
  disabledModules = [
    "services/desktop-managers/cosmic.nix"
    "services/display-managers/cosmic-greeter.nix"
  ];
  imports = [
    "${unstableModules}/desktop-managers/cosmic.nix"
    "${unstableModules}/display-managers/cosmic-greeter.nix"
  ];

  config = lib.mkMerge [
    {
      nixpkgs.overlays = [
        (final: prev:
          lib.filterAttrs (name: _: isCosmicPackage name)
          inputs.nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system})
      ];
    }
    (lib.mkIf (config.my.desktop.environment == "cosmic") {
      services.desktopManager.cosmic.enable = true;
      services.displayManager.cosmic-greeter.enable = true;
    })
  ];
}
