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

    # Disable CEF GPU compositing in steam so hardware accelerated GPU
    # rendering in webviews don't show a black screen
    (final: prev: {
      steam = prev.steam.override {
        extraArgs = "-cef-disable-gpu-compositing";
      };
    })

    (final: prev: {
      llama-cpp = prev.llama-cpp.override {cudaSupport = true;};
    })
  ];
}
