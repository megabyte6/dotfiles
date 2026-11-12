{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.features.printing.enable = lib.mkEnableOption "printing via CUPS and network printer discovery";

  config = lib.mkIf config.my.features.printing.enable {
    services = {
      # Printing via CUPS
      printing = {
        enable = true;
        drivers = with pkgs; [
          cups-filters
          cups-browsed
        ];
      };
      # Network printer/service discovery
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
