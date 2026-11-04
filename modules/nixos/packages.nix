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

  services.flatpak.packages = [
    "net.veloren.airshipper" # Airshipper
    "io.anytype.anytype" # Anytype
    "io.appflowy.AppFlowy" # AppFlowy
    "org.gnome.FileRoller" # Archive Manager
    "io.github.nokse22.asciidraw" # AsciiDraw
    "com.ulduzsoft.Birdtray" # Birdtray
    "net.blockbench.Blockbench" # Blockbench
    "com.usebottles.bottles" # Bottles
    "com.usebruno.Bruno" # Bruno
    "org.gnome.Calculator" # Calculator
    "org.gnome.Snapshot" # Camera
    "org.gnome.Characters" # Characters
    "org.gnome.Connections" # Connections
    "org.gnome.Decibels" # Decibels
    "com.belmoussaoui.Decoder" # Decoder
    "com.discordapp.Discord" # Discord
    "im.riot.Riot" # Element
    "org.gnome.design.Emblem" # Emblem
    "com.github.tchx84.Flatseal" # Flatseal
    "org.gnome.font-viewer" # Fonts
    "org.ghidra_sre.Ghidra" # Ghidra
    "org.gimp.GIMP" # GIMP
    "org.godotengine.Godot" # Godot
    "org.gnome.design.IconLibrary" # Icon Library
    "org.gnome.Loupe" # Image Viewer
    "org.inkscape.Inkscape" # Inkscape
    "org.kde.kdenlive" # Kdenlive
    "org.libreoffice.LibreOffice" # LibreOffice
    "org.gnome.Logs" # Logs
    "io.mpv.Mpv" # mpv
    "com.belmoussaoui.Obfuscate" # Obfuscate
    "com.obsproject.Studio" # OBS Studio
    "io.github.nozwock.Packet" # Packet
    "org.gnome.Papers" # Papers
    "de.swsnr.pictureoftheday" # Picture of the Day
    "org.gnome.World.PikaBackup" # Pika Backup
    "org.prismlauncher.PrismLauncher" # Prism Launcher
    "ch.protonmail.protonmail-bridge" # Proton Mail Bridge
    "com.protonvpn.www" # Proton VPN
    "org.gnome.SimpleScan" # Simple Scan
    "io.github.pwr_solaar.solaar" # Solaar
    "com.spotify.Client" # Spotify
    "org.stellarium.Stellarium" # Stellarium
    "com.stremio.Stremio" # Stremio
    "io.gitlab.adhami3310.Converter" # Switcheroo
    "org.gnome.TextEditor" # Text Editor
    "io.gitlab.liferooter.TextPieces" # Text Pieces
    "org.mozilla.thunderbird" # Thunderbird
    "io.gitlab.theevilskeleton.Upscaler" # Upscaler
    "org.upscayl.Upscayl" # Upscayl
    "org.videolan.VLC" # VLC
    "io.github.flattool.Warehouse" # Warehouse
  ];
}
