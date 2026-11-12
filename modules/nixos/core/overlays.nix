{inputs, ...}: {
  nixpkgs.overlays = [
    # Expose the unstable channel as `pkgs.unstable`, so individual packages
    # can be pulled from unstable with `unstable.<name>` (inside `with pkgs;`)
    # or `pkgs.unstable.<name>` elsewhere.
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (prev.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    })
  ];
}
