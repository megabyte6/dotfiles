{pkgs, ...}: {
  # List packages installed system-wide. To search: `nix search nixpkgs wget`.
  # Packages prefixed with `unstable.` come from the unstable overlay.
  environment.systemPackages = with pkgs; [
    # neovim build deps
    unzip
    gcc

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
