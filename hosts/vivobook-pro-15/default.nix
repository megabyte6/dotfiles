{...}: {
  imports = [
    # Machine-specific hardware scan. Copy your existing hardware configuration
    # (/etc/nixos/hardware-configuration.nix) to this directory.
    ./hardware-configuration.nix
    ./hardware.nix
  ];

  my.desktop.enable = true;

  my.features = {
    gaming.enable = true;
    llm.enable = true;
    printing.enable = true;
    reverseEngineering.enable = true;
    virtualisation.enable = true;
    ensc351 = {
      enable = true;
      externalInterface = "wlo1";
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
