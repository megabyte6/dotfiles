{pkgs, ...}: {
  services = {
    # Printing via CUPS
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-filters
        cups-browsed
      ];
    };
    # Network printer/service discovery
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    # Trash and remote mounts for Nautilus
    gvfs.enable = true;

    flatpak.enable = true;

    llama-cpp.enable = true;
  };
}
