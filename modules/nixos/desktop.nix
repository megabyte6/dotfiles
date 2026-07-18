{pkgs, ...}: {
  services.greetd = {
    enable = true;
    settings.default_session.command = ''
      ${pkgs.tuigreet}/bin/tuigreet \
      --sessions ${pkgs.niri}/share/wayland-sessions \
      --time \
      --remember \
      --remember-user-session \
      --user-menu \
      --asterisks
    '';
  };

  programs.niri.enable = true;

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

  security.soteria.enable = true;

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
