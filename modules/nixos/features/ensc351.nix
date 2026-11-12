{
  config,
  lib,
  ...
}: let
  cfg = config.my.features.ensc351;
  boardInterface = "beagle0";
  # Find with: `ip a` (link/ether of the board's USB Ethernet device)
  boardMac = "1C:BA:8C:A2:ED:6A";
in {
  options.my.features.ensc351 = {
    enable = lib.mkEnableOption "ENSC 351 BeagleY-AI board networking (NAT and NFS share)";

    externalInterface = lib.mkOption {
      type = lib.types.str;
      example = "wlo1";
      description = "Host interface that provides internet access to the board via NAT. Find with `ip a`.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager.ensureProfiles.profiles = {
        "BeagleY-AI" = {
          connection = {
            id = "BeagleY-AI";
            type = "ethernet";
          };
          ethernet.mac-address = boardMac;
          ipv4 = {
            method = "auto";
            never-default = true;
          };
        };
      };

      nat = {
        enable = true;
        internalInterfaces = [boardInterface];
        inherit (cfg) externalInterface;
      };

      firewall.interfaces."${boardInterface}".allowedTCPPorts = [2049];
    };

    # Pin a stable name by MAC, since the kernel's name changes with the USB port.
    systemd.network.links."10-beagle" = {
      matchConfig.PermanentMACAddress = boardMac;
      linkConfig.Name = boardInterface;
    };

    # Shared folder, world-writable.
    systemd.tmpfiles.rules = [
      "d /srv/ensc351/public 0777 brayden users"
    ];

    services.nfs.server = {
      enable = true;
      # No space before the "(" as a stray space causes "permission denied".
      exports = ''
        /srv/ensc351/public 192.168.7.0/24(rw,all_squash,anonuid=1000,anongid=100)
      '';
    };
  };
}
