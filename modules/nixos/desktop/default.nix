{lib, ...}: {
  options.my.desktop.enable = lib.mkEnableOption "the graphical desktop (niri + Noctalia, fonts, audio, apps, flatpaks)";

  imports = [
    ./apps.nix
    ./audio.nix
    ./flatpak.nix
    ./fonts.nix
    ./niri.nix
    ./packages.nix
  ];
}
