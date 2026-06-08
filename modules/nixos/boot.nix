{...}: {
  boot = {
    loader = {
      # systemd-boot boots faster than GRUB on EFI systems
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi.canTouchEfiVariables = true;
    };

    # Reduces kernel logging spam, but may hide warnings
    consoleLogLevel = 3;
    # Hide console output with a nice logo on boot
    plymouth.enable = true;
  };
}
