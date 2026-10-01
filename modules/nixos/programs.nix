{
  config,
  pkgs,
  ...
}: {
  programs = {
    fish.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
    };

    direnv.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    gnupg.agent.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    gamemode.enable = true;

    nix-index-database.comma.enable = true;

    binary-ninja = {
      enable = true;
      package = pkgs.binary-ninja-personal-wayland;
    };

    gnome-disks.enable = true;

    localsend.enable = true;

    # Allow for running unpatched dynamic binaries (the libraries they expect at
    # runtime). Editors often try to download and run Language server binaries.
    # Just add any missing libraries here.
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib

        # required for niri
        libsecret

        # required by zed's slint extension
        wayland
        libxkbcommon
        libinput
        libgbm
        fontconfig
        freetype
      ];
    };
  };

  # Keep the installer zip alive as long as this generation exists
  system.extraDependencies = [config.programs.binary-ninja.package.src];
}
