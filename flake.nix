{
  description = "My flake-based NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Exposed as `pkgs.unstable` via an overlay
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    tuigreet.url = "github:NotAShelf/tuigreet";
  };

  outputs = {
    nixpkgs,
    nix-flatpak,
    ...
  } @ inputs: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    forEachSupportedSystem = f:
      inputs.nixpkgs.lib.genAttrs supportedSystems (
        system:
          f {
            inherit system;
            pkgs = import inputs.nixpkgs {inherit system;};
          }
      );
  in {
    nixosConfigurations.vivobook-pro-15 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # Make all flake inputs available to every module as `inputs`
      specialArgs = {inherit inputs;};

      modules = [
        nix-flatpak.nixosModules.nix-flatpak

        ./hosts/vivobook-pro-15
      ];
    };

    # `nix fmt` formats the whole repo with alejandra
    formatter = forEachSupportedSystem ({pkgs, ...}: pkgs.alejandra);
  };
}
