{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.my.desktop.environment == "cosmic") {
    services.desktopManager.cosmic.enable = true;
    services.displayManager.cosmic-greeter.enable = true;
  };
}
