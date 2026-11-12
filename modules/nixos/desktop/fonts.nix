{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.my.desktop.enable {
    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-color-emoji
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        liberation_ttf
        carlito
        nerd-fonts.jetbrains-mono
      ];
      fontconfig.defaultFonts = {
        monospace = ["JetBrainsMono Nerd Font" "Noto Sans Mono"];
        sansSerif = ["Noto Sans"];
        serif = ["Noto Serif"];
      };
    };
  };
}
