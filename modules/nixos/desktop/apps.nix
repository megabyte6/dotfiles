{
  config,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.mkIf config.my.desktop.enable {
      programs = {
        seahorse.enable = true;
        kdeconnect.enable = true;
        gnome-disks.enable = true;
        localsend.enable = true;
      };
    })

    # Nautilus is the file manager on niri and GNOME (COSMIC has its own).
    (lib.mkIf (builtins.elem config.my.desktop.environment ["niri" "gnome"]) {
      programs.nautilus-open-any-terminal = {
        enable = true;
        terminal = "ghostty";
      };
    })
  ];
}
