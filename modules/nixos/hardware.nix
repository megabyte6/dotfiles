{...}: {
  # Graphics / NVIDIA PRIME (Intel iGPU + NVIDIA dGPU offload)
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];
  hardware.nvidia = {
    open = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # NOTE: These bus IDs are specific to this machine. Verify with `lspci`.
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    powerManagement = {
      enable = true;
      finegrained = true;
    };
  };

  hardware.bluetooth.enable = true;

  # Power management
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Suspend behaviour
  services.logind.settings.Login = {
    KillUserProcesses = false;
    HandleLidSwitchDocked = "suspend";
  };

  # Disable wakeup from a specific PCI device. The device path is
  # machine-specific. Verify against `cat /proc/acpi/wakeup` and sysfs.
  systemd.services.disableWakeup = {
    description = "Disable unwanted PCI device wakeup";
    wantedBy = ["multi-user.target"];
    after = ["local-fs.target"]; # ensure /sys is available
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c 'echo disabled > /sys/bus/pci/devices/0000:00:01.0/power/wakeup'";
    };
  };
}
