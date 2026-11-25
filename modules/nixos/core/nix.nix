{inputs, ...}: {
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };

    # Add `unstable` to the system flake registry, pinned to this flake's locked
    # nixpkgs-unstable, so `nix run unstable#foo` / `nix shell unstable#foo` get
    # newer packages (matching `pkgs.unstable`). `nixpkgs` stays pinned to the
    # system's stable nixpkgs, which NixOS sets up by default.
    registry.unstable.flake = inputs.nixpkgs-unstable;

    # Automatic runs are performed by the upgrade service in update.nix
    gc = {
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
