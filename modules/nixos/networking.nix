{pkgs, ...}: {
  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        # For StackSmash VPN network
        networkmanager-openvpn
        # For SFU VPN network
        # ---------------------------------------------------------------------
        # networkmanager-fortisslvpn is flagged insecure (CVE-2026-91839) in
        # the pinned nixpkgs. Uncomment once a fixed version lands.
        # ---------------------------------------------------------------------
        #networkmanager-fortisslvpn
      ];
    };

    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];

    # Configure a network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
}
