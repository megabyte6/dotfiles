{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.my.desktop.enable {
    # Packages prefixed with `unstable.` come from the unstable overlay.
    environment.systemPackages = with pkgs; [
      # niri / wayland shell
      xwayland-satellite
      wl-clipboard
      brightnessctl
      hyprpicker

      # theming
      adwaita-icon-theme
      nordzy-cursor-theme

      # zed
      unstable.zed-editor
      nixd

      unstable.ghostty
      brave
      unstable.vscode
      unstable.jetbrains.idea
      unstable.proton-authenticator
      unstable.nirimod

      # the flatpak versions of these apps do not work well
      nautilus
      baobab
    ];
  };
}
