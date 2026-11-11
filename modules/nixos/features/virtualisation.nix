{pkgs, ...}: {
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [virtiofsd];
    };
    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;
}
