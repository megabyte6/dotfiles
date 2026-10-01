{...}: let
  # Find the interface name with: `ip a` (look for enx...)
  beagleInterfaceName = "enx1cba8ca2ed6a";
in {
  networking = {
    networkmanager.ensureProfiles.profiles = {
      "BeagleY-AI USB" = {
        connection = {
          id = "BeagleY-AI USB";
          type = "ethernet";
          interface-name = beagleInterfaceName;
        };
        ipv4 = {
          method = "auto";
          never-default = true;
        };
      };
    };

    nat = {
      enable = true;
      internalInterfaces = [beagleInterfaceName];
      externalInterface = "wlo1";
    };

    # Allow NFS only on the USB-Ethernet link to the board.
    firewall.interfaces."${beagleInterfaceName}".allowedTCPPorts = [2049];
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
