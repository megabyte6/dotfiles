{
  config,
  lib,
  ...
}: let
  cfg = config.my.desktop;
in {
  options.my.desktop = {
    environment = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum ["niri" "gnome" "cosmic"]);
      default = null;
      example = "gnome";
      description = ''
        The desktop environment, along with its login greeter. Change this and
        rebuild to swap. `null` means no graphical desktop.

        - `niri`: niri with the Noctalia shell and greeter
        - `gnome`: GNOME with GDM
        - `cosmic`: COSMIC with its greeter
      '';
    };

    enable = lib.mkOption {
      type = lib.types.bool;
      readOnly = true;
      default = cfg.environment != null;
      defaultText = lib.literalExpression "config.my.desktop.environment != null";
      description = "Whether any desktop is selected. Gates the shared base (fonts, audio, apps, flatpaks). Set `environment` instead.";
    };
  };

  imports = [
    ./apps.nix
    ./audio.nix
    ./cosmic.nix
    ./flatpak.nix
    ./fonts.nix
    ./gnome.nix
    ./niri.nix
    ./packages.nix
  ];

  config = lib.mkIf cfg.enable {
    # lockAll means these can't be changed from GNOME Settings either.
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
