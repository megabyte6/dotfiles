{...}: {
  imports = [
    # Machine-specific hardware scan. Copy your existing hardware configuration
    # (/etc/nixos/hardware-configuration.nix) to this directory.
    ./hardware-configuration.nix

    ../../modules/nixos
  ];

  networking.hostName = "vivobook-pro-15";

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
