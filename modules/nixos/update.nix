{
  config,
  pkgs,
  ...
}: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:megabyte6/dotfiles#${config.networking.hostName}";
    flags = ["--print-build-logs"];
    dates = "21:15";
    runGarbageCollection = true;
  };

  # Wait for network connectivity before attempting an upgrade
  systemd.services.nixos-upgrade.serviceConfig.ExecStartPre = let
    waitForNetwork = pkgs.writeShellScript "wait-for-network" ''
      i=0
      until ${pkgs.curl}/bin/curl --silent --fail --max-time 5 https://channels.nixos.org > /dev/null; do
        sleep 2
        i=$((i + 1))
        if [ $i -ge 15 ]; then
          exit 1
        fi
      done
    '';
  in ["${waitForNetwork}"];

  services.flatpak = {
    uninstallUnmanaged = true;
    update.auto = {
      enable = true;
      onCalendar = "daily";
    };
  };
}
