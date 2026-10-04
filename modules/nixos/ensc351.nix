{...}: let
  boardInterface = "beagle0";
  # Find with: `ip a` (link/ether of the board's USB Ethernet device)
  boardMac = "1C:BA:8C:A2:ED:6A";
in {
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
      externalInterface = "wlo1";
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
      /srv/ensc351/public 192.168.7.0/24(all_squash,anonuid=1000,anongid=100)
    '';
  };
}
