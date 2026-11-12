{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.user;
in {
  options.my.user = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "brayden";
      description = "Login name of the primary user. Other modules use this instead of hardcoding it.";
    };
    description = lib.mkOption {
      type = lib.types.str;
      default = "Brayden Chan";
      description = "Full name of the primary user.";
    };
  };

  config.users.users.${cfg.name} = {
    isNormalUser = true;
    inherit (cfg) description;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };
}
