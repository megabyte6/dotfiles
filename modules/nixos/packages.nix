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

  services.flatpak.packages = [
    "com.belmoussaoui.Decoder"
    "com.belmoussaoui.Obfuscate"
    "com.discordapp.Discord"
    "com.github.tchx84.Flatseal"
    "com.obsproject.Studio"
    "com.protonvpn.www"
    "com.spotify.Client"
    "com.stremio.Stremio"
    "com.usebottles.bottles"
    "com.usebruno.Bruno"
    "de.swsnr.pictureoftheday"
    "im.riot.Riot"
    "io.anytype.anytype"
    "io.appflowy.AppFlowy"
    "io.github.flattool.Warehouse"
    "io.github.mgerhardy.vengi.voxedit"
    "io.github.nokse22.asciidraw"
    "io.github.nozwock.Packet"
    "io.github.pwr_solaar.solaar"
    "io.gitlab.adhami3310.Converter"
    "io.gitlab.liferooter.TextPieces"
    "io.gitlab.theevilskeleton.Upscaler"
    "io.mpv.Mpv"
    "me.iepure.devtoolbox"
    "net.blockbench.Blockbench"
    "net.veloren.airshipper"
    "org.ghidra_sre.Ghidra"
    "org.gimp.GIMP"
    "org.gnome.Calculator"
    "org.gnome.Characters"
    "org.gnome.Connections"
    "org.gnome.Decibels"
    "org.gnome.FileRoller"
    "org.gnome.Logs"
    "org.gnome.Loupe"
    "org.gnome.Papers"
    "org.gnome.SimpleScan"
    "org.gnome.Snapshot"
    "org.gnome.TextEditor"
    "org.gnome.World.PikaBackup"
    "org.gnome.design.Emblem"
    "org.gnome.design.IconLibrary"
    "org.gnome.font-viewer"
    "org.inkscape.Inkscape"
    "org.kde.kdenlive"
    "org.libreoffice.LibreOffice"
    "org.localsend.localsend_app"
    "org.mozilla.thunderbird"
    "org.onlyoffice.desktopeditors"
    "org.prismlauncher.PrismLauncher"
    "org.radare.iaito"
    "org.stellarium.Stellarium"
    "org.upscayl.Upscayl"
    "org.videolan.VLC"
    "re.rizin.cutter"
    "re.rizin.cutter.plugin.rz-ghidra"
  ];
}
