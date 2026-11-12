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
  # everything below is gated on the desktop toggle.
  config = lib.mkIf config.my.desktop.enable {
    programs.niri.enable = true;

    programs.noctalia = {
      enable = true;
      recommendedServices.enable = true;
      systemd.enable = true;
      package = pkgs.unstable.noctalia;
    };

    services.displayManager.noctalia-greeter = {
      enable = true;
      package = pkgs.unstable.noctalia-greeter;
    };

    programs.dconf.profiles.user.databases = [
      {
        lockAll = true;
        settings = {
          "org/gnome/desktop/interface".color-scheme = "prefer-dark";
          "org/gtk/settings/file-chooser".sort-directories-first = true;
        };
      }
    ];
  };
}
