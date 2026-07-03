{
  config,
  pkgs,
  lib,
  ...
}: {
  assertions = [
    {
      assertion = config.systemd.services.nixos-upgrade.script != "";
      message = "nixos-upgrade no longer defines `script`; update the sleep-inhibit wrapper in update.nix";
    }
  ];

  system.autoUpgrade = {
    enable = true;
    flake = "github:megabyte6/dotfiles#${config.networking.hostName}";
    flags = ["--print-build-logs"];
    runGarbageCollection = true;
  };

  services.flatpak = {
    uninstallUnmanaged = true;
    update.auto.enable = true;
  };

  systemd = {
    services.nixos-upgrade.serviceConfig = {
      ExecStartPre = let
        # A WakeSystem RTC wake while the lid is still closed races logind's lid-switch handler,
        # which immediately starts a new suspend. logind then refuses any new inhibitor with
        # "already running" for as long as that sleep is actually in progress (i.e. until the
        # machine truly wakes again), so retry a cheap throwaway inhibitor acquisition instead of
        # gambling on a fixed delay.
        waitForInhibit = pkgs.writeShellScript "wait-for-sleep-inhibit" ''
          i=0
          until ${config.systemd.package}/bin/systemd-inhibit \
              --what=idle:sleep:handle-lid-switch --who=nixos-upgrade \
              --why="System updates in progress" --mode=block true 2>/dev/null; do
            i=$((i + 1))
            if [ $i -ge 40 ]; then
              exit 0
            fi
            sleep 3
          done
        '';
      in ["${waitForInhibit}"];

      ExecStart = let
        fullUpdate = pkgs.writeShellScript "full-update" ''
          # Wait for internet connectivity
          ${pkgs.curl}/bin/curl --silent --fail --connect-timeout 5 \
            --retry 20 --retry-delay 3 --retry-all-errors --retry-max-time 60 \
            https://github.com > /dev/null || exit 1

          # Run the Flatpak update in parallel. `restart` (not `start`) forces the oneshot to
          # re-run each day even if it is still marked active from a previous run.
          ${config.systemd.package}/bin/systemctl restart flatpak-managed-install-timer.service &
          flatpak_pid=$!

          # Save the exit status to pass as the exit status of the service
          status=0
          ${pkgs.writeShellScript "nixos-upgrade-script" config.systemd.services.nixos-upgrade.script} || status=$?

          if ! wait "$flatpak_pid"; then
            echo "flatpak-managed-install-timer failed; continuing" >&2
          fi

          # Use the exit status from the NixOS update instead of the Flatpak update
          exit "$status"
        '';
      in
        lib.mkForce "${config.systemd.package}/bin/systemd-inhibit --what=idle:sleep:handle-lid-switch --who=nixos-upgrade --why='System updates in progress' --mode=block ${fullUpdate}";

      ExecStopPost = let
        suspendIfLidClosed = pkgs.writeShellScript "suspend-if-lid-closed" ''
          lid=$(cat /proc/acpi/button/lid/*/state 2>/dev/null | ${pkgs.gawk}/bin/awk '{print $2}')
          if [ "$lid" = "closed" ]; then
            systemctl suspend
          fi
        '';
      in ["${suspendIfLidClosed}"];
    };

    timers = {
      nixos-upgrade.timerConfig.WakeSystem = true;

      # The flatpak update is driven by the nixos-upgrade.service above
      flatpak-managed-install-timer.enable = lib.mkForce false;
    };
  };
}
