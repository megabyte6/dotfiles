{...}: {
  # Power management
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Suspend behaviour
  services.logind.settings.Login = {
    KillUserProcesses = false;
    HandleLidSwitchDocked = "suspend";
  };
}
