# Hand-written hardware configuration for this machine: which hardware it has,
# machine-specific values, and quirks. hardware-configuration.nix is generated
# by `nixos-generate-config` and should not be edited by hand.
{...}: {
  my.hardware = {
    nvidia = {
      enable = true;
      prime = {
        enable = true;
        # Verify with `lspci`.
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    laptop.enable = true;
    faceUnlock.enable = true;
  };

  hardware.bluetooth.enable = true;

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
