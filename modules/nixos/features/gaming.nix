{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.features.gaming.enable = lib.mkEnableOption "Steam, Proton GE and GameMode";

  config = lib.mkIf config.my.features.gaming.enable {
    programs = {
      steam = {
        enable = true;
        # Disable CEF GPU compositing so Steam's webviews don't render black or
        # glitch on Linux, especially under niri/xwayland-satellite or NVIDIA.
        package = pkgs.steam.override {
          extraArgs = "-cef-disable-gpu-compositing";
        };
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
      gamemode.enable = true;
    };
  };
}
