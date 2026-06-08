{pkgs, ...}: {
  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        # For StackSmash VPN network
        networkmanager-openvpn
      ];
    };

    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];

    # Configure a network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
}
