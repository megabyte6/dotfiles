{
  config,
  lib,
  ...
}: let
  cfg = config.my.hardware.nvidia;
in {
  options.my.hardware.nvidia = {
    enable = lib.mkEnableOption "NVIDIA GPU support (open kernel modules)";

    prime = {
      enable = lib.mkEnableOption "PRIME render offload for hybrid Intel iGPU + NVIDIA dGPU systems";

      # No defaults: these are machine-specific, so a host that enables PRIME
      # without setting them fails at evaluation instead of at boot.
      intelBusId = lib.mkOption {
        type = lib.types.str;
        example = "PCI:0:2:0";
        description = "PCI bus ID of the Intel iGPU. Find with `lspci`.";
      };
      nvidiaBusId = lib.mkOption {
        type = lib.types.str;
        example = "PCI:1:0:0";
        description = "PCI bus ID of the NVIDIA dGPU. Find with `lspci`.";
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.prime.enable -> cfg.enable;
        message = "my.hardware.nvidia.prime.enable requires my.hardware.nvidia.enable";
      }
    ];

    hardware = lib.mkIf cfg.enable {
      graphics.enable = true;

      nvidia = lib.mkMerge [
        {open = true;}

        (lib.mkIf cfg.prime.enable {
          prime = {
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };
            inherit (cfg.prime) intelBusId nvidiaBusId;
          };
          # Fine-grained power management powers the dGPU down when idle,
          # which only works with offload.
          powerManagement = {
            enable = true;
            finegrained = true;
          };
        })
      ];
    };

    # With PRIME the iGPU drives the display, so it needs its own driver too.
    services.xserver.videoDrivers = lib.mkIf cfg.enable (
      lib.optional cfg.prime.enable "modesetting" ++ ["nvidia"]
    );
  };
}
