{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.my.desktop.enable {
    # Packages prefixed with `unstable.` come from the unstable overlay.
    environment.systemPackages = with pkgs; [
      # wl-copy/wl-paste for terminal tools. No desktop ships it.
      wl-clipboard

      # zed
      unstable.zed-editor
      nixd

      unstable.ghostty
      brave
      unstable.vscode
      unstable.jetbrains.idea
      unstable.proton-authenticator
    ];
  };
}
