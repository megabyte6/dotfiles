{
  config,
  lib,
  ...
}: {
  options.my.profiles.workstation.enable = lib.mkEnableOption "the workstation profile: a personal graphical machine with the usual features";

  # Everything uses mkDefault so a host can still turn off any single item
  # with a plain `= false`.
  config = lib.mkIf config.my.profiles.workstation.enable {
    my.desktop.environment = lib.mkDefault "gnome";

    my.features = {
      gaming.enable = lib.mkDefault true;
      llm.enable = lib.mkDefault true;
      printing.enable = lib.mkDefault true;
      reverseEngineering.enable = lib.mkDefault true;
      virtualisation.enable = lib.mkDefault true;
    };

    hardware.bluetooth.enable = lib.mkDefault true;
  };
}
