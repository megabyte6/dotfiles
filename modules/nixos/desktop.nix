{pkgs, inputs, ...}: let
  noctaliaPath = "nixos/modules/programs/wayland/noctalia.nix";
  noctaliaGreeterPath = "nixos/modules/services/display-managers/noctalia-greeter.nix";
in {
  imports = [
    (
      if builtins.pathExists "${inputs.nixpkgs}/${noctaliaPath}"
      then throw "noctalia: module has landed in stable nixpkgs. Drop this import and the `package` override in modules/nixos/desktop.nix."
      else "${inputs.nixpkgs-unstable}/${noctaliaPath}"
    )
    (
      if builtins.pathExists "${inputs.nixpkgs}/${noctaliaGreeterPath}"
      then throw "noctalia-greeter: module has landed in stable nixpkgs. Drop this import and the `package` override in modules/nixos/desktop.nix."
      else "${inputs.nixpkgs-unstable}/${noctaliaGreeterPath}"
    )
  ];

  programs.niri.enable = true;

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    systemd.enable = true;
    package = pkgs.unstable.noctalia;
  };

  services.displayManager.noctalia-greeter = {
    enable = true;
    package = pkgs.unstable.noctalia-greeter;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      nerd-fonts.jetbrains-mono
      liberation_ttf
    ];
    fontconfig.defaultFonts = {
      monospace = ["Noto Sans Mono"];
      sansSerif = ["Noto Sans"];
      serif = ["Noto Serif"];
    };
  };

  programs.seahorse.enable = true;
  programs.kdeconnect.enable = true;
  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "ghostty";
  };

  programs.dconf.profiles.user.databases = [
    {
      lockAll = true;
      settings = {
        "org/gnome/desktop/interface".color-scheme = "prefer-dark";
        "org/gtk/settings/file-chooser".sort-directories-first = true;
      };
    }
  ];
}
