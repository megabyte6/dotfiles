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
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };
      gamemode.enable = true;
    };
  };
}
