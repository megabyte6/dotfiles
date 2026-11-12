{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.features.virtualisation.enable = lib.mkEnableOption "Podman, libvirt/QEMU with virt-manager, and distrobox";

  config = lib.mkIf config.my.features.virtualisation.enable {
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

    environment.systemPackages = with pkgs; [
      distrobox
    ];
  };
}
