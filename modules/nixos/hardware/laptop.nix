{
  config,
  lib,
  ...
}: {
  options.my.hardware.laptop.enable = lib.mkEnableOption "laptop power management and lid handling";

  config = lib.mkIf config.my.hardware.laptop.enable {
    # Power management
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;

    # Suspend behaviour
    services.logind.settings.Login = {
      KillUserProcesses = false;
      HandleLidSwitchDocked = "suspend";
    };
  };
}
