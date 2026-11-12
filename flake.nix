{
  description = "My flake-based NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # exposed as `pkgs.unstable` via an overlay
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    binaryninja = {
      url = "github:jchv/nix-binary-ninja";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
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
    # Every directory in hosts/ becomes a nixosConfiguration of the same name.
    # The architecture comes from each host's hardware-configuration.nix
    # (nixpkgs.hostPlatform), so it isn't set here.
    nixosConfigurations = let
      mkHost = name:
        nixpkgs.lib.nixosSystem {
          # Make all flake inputs available to every module as `inputs`
          specialArgs = {inherit inputs;};

          modules = [
            ./hosts/${name}
            ./modules/nixos
            # The directory name is the hostname. Auto-upgrade relies on this to
            # find the host's configuration (`#${config.networking.hostName}`).
            {networking.hostName = name;}
          ];
        };
      hostNames = builtins.attrNames (
        nixpkgs.lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./hosts)
      );
    in
      nixpkgs.lib.genAttrs hostNames mkHost;

    # `nix fmt` formats the whole repo with alejandra
    formatter = forEachSupportedSystem ({pkgs, ...}: pkgs.alejandra);
  };
}
