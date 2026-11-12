{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.my.desktop.environment == "gnome") {
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      # Already installed as flatpaks (flatpak.nix), which stay the same across
      # every desktop.
      decibels
      gnome-calculator
      gnome-characters
      gnome-connections
      gnome-font-viewer
      gnome-logs
      gnome-text-editor
      loupe
      papers
      simple-scan
      snapshot

      # Flatpaks are managed declaratively with uninstallUnmanaged, so anything
      # installed through GNOME Software gets removed on the next rebuild.
      gnome-software
    ];
  };
}
