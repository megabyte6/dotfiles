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
}
