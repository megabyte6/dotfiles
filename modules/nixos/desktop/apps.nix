{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.my.desktop.enable {
    programs = {
      seahorse.enable = true;
      kdeconnect.enable = true;
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "ghostty";
      };
      gnome-disks.enable = true;
      localsend.enable = true;
    };

    # Trash and remote mounts for Nautilus
    services.gvfs.enable = true;
  };
}
