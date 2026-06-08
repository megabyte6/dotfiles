{
  config,
  pkgs,
  ...
}: {
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  system.autoUpgrade = {
    enable = true;
    flake = "/home/brayden/dotfiles#${config.networking.hostName}";
    flags = [
      "--print-build-logs"
      # Comment the following to stop refreshing inputs each run
      # (and updating flake.lock). Updating will have to be done manually with
      # `nix flake update`.
      "--recreate-lock-file"
    ];
    dates = "21:15";
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
