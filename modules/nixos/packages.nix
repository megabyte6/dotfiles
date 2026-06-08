{pkgs, ...}: {
  # List packages installed system-wide. To search: `nix search nixpkgs wget`.
  # Packages prefixed with `unstable.` come from the unstable overlay.
  environment.systemPackages = with pkgs; [
    # niri / wayland shell
    xwayland-satellite
    unstable.noctalia-shell
    unstable.vicinae
    wl-clipboard
    brightnessctl
    hyprpicker

    # theming
    adwaita-icon-theme
    nordzy-cursor-theme

    # zed
    unstable.zed-editor
    nixd
    nil

    # neovim build deps
    unzip
    gcc

    # GUI apps
    unstable.ghostty
    brave
    unstable.vscode
    unstable.jetbrains.idea

    proton-authenticator
    wireshark
    openfortivpn
    unstable.binaryninja-free

    nautilus
    baobab
    gnome-disk-utility

    # terminal apps
    unstable.llama-cpp

    # terminal tools
    fzf
    ripgrep
    fd
    jq
    bat
    bat-extras.batman
    delta
    httpie
    btop
    fastfetch
    zellij
    distrobox
    ffmpeg
    trash-cli
    codesnap
    act

    # languages / formatters
    alejandra
    python314

    # manpages
    man-pages
    man-pages-posix

    # for the default libvirt network
    dnsmasq
  ];
}
