{pkgs, ...}: {
  # List packages installed system-wide. To search: `nix search nixpkgs wget`.
  # Packages prefixed with `unstable.` come from the unstable overlay.
  environment.systemPackages = with pkgs; [
    # niri / wayland shell
    xwayland-satellite
    wl-clipboard
    brightnessctl
    hyprpicker

    # theming
    adwaita-icon-theme
    nordzy-cursor-theme

    # zed
    unstable.zed-editor
    nixd

    # neovim build deps
    unzip
    gcc

    # GUI apps
    unstable.ghostty
    brave
    unstable.vscode
    unstable.jetbrains.idea

    unstable.proton-authenticator
    wireshark
    unstable.nirimod

    nautilus
    baobab

    # CLI tools
    fzf
    ripgrep
    fd
    jq
    bat
    bat-extras.batman
    delta
    httpie
    fastfetch
    ffmpeg
    trash-cli
    distrobox
    codesnap
    act

    # TUIs
    zellij
    btop
    claude-code

    python315

    # man pages
    man-pages
    man-pages-posix
  ];
}
