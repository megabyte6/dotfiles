{pkgs, ...}: {
  users.users.brayden = {
    isNormalUser = true;
    description = "Brayden Chan";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
    shell = pkgs.fish;
  };
}
