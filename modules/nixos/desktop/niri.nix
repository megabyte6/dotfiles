{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  noctaliaPath = "nixos/modules/programs/wayland/noctalia.nix";
  noctaliaGreeterPath = "nixos/modules/services/display-managers/noctalia-greeter.nix";
in {
  imports = [
    {
      # Compat stub: the unstable noctalia-greeter module sets this option, but it
      # doesn't exist in stable's polkit module yet. Remove when noctalia lands in
      # stable.
      options.security.polkit.enablePkexecWrapper = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Stub for compatibility with the unstable noctalia-greeter module.";
      };
    }
    (
      if builtins.pathExists "${inputs.nixpkgs}/${noctaliaPath}"
      then throw "noctalia: module has landed in stable nixpkgs. Drop this import and the `package` override in modules/nixos/desktop/niri.nix."
      else "${inputs.nixpkgs-unstable}/${noctaliaPath}"
    )
    (
      if builtins.pathExists "${inputs.nixpkgs}/${noctaliaGreeterPath}"
      then throw "noctalia-greeter: module has landed in stable nixpkgs. Drop this import and the `package` override in modules/nixos/desktop/niri.nix."
      else "${inputs.nixpkgs-unstable}/${noctaliaGreeterPath}"
    )
  ];

  # The imports above stay unconditional (they only declare options);
  # everything below only applies when niri is the selected environment.
  config = lib.mkIf (config.my.desktop.environment == "niri") {
    programs.niri.enable = true;

    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
      systemd = {
        enable = true;
        # The default (graphical-session.target) would start Noctalia in any
        # graphical session. Tie it to niri.
        target = "niri.service";
      };
      package = pkgs.unstable.noctalia;
    };

    services.displayManager.noctalia-greeter = {
      enable = true;
      package = pkgs.unstable.noctalia-greeter;
    };

    # Trash and remote mounts for Nautilus
    services.gvfs.enable = true;

    # GNOME and COSMIC ship their own versions of the theming and apps below.
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      brightnessctl
      hyprpicker
      unstable.nirimod

      # theming
      adwaita-icon-theme
      nordzy-cursor-theme

      # the flatpak versions of these apps do not work well
      nautilus
      baobab
    ];
  };
}
