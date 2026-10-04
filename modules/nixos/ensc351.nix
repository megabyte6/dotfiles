{...}: let
  # Fixed name assigned by the .link rule below, so either USB port works.
  beagleInterface = "beagle0";
  # Find with: `ip a` (link/ether of the board's USB Ethernet device)
  beagleMac = "1C:BA:8C:A2:ED:6A";
in {
  networking = {
    networkmanager.ensureProfiles.profiles = {
      "BeagleY-AI USB" = {
        connection = {
          id = "BeagleY-AI USB";
          type = "ethernet";
          autoconnect-priority = 100;
        };
        ethernet.mac-address = beagleMac;
        ipv4 = {
          method = "auto";
          never-default = true;
        };
      };
    };

    nat = {
      enable = true;
      internalInterfaces = [beagleInterface];
      externalInterface = "wlo1";
    };

    # Allow NFS only on the USB-Ethernet link to the board.
    firewall.interfaces."${beagleInterface}".allowedTCPPorts = [2049];
  };

  # Rename the board's USB Ethernet device by MAC regardless of USB port.
  systemd.network.links."10-beagle" = {
    matchConfig.PermanentMACAddress = beagleMac;
    linkConfig.Name = beagleInterface;
  };

  # Shared folder, world-writable.
  systemd.tmpfiles.rules = [
    "d /srv/ensc351/public 0777 brayden users -"
  ];

  services.nfs.server = {
    enable = true;
    # No space before the "(" as a stray space causes "permission denied".
    exports = ''
      /srv/ensc351/public 192.168.7.0/24(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=100)
    '';
  };
}
