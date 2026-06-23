# dotfiles

NixOS configuration, managed as a flake.

## Layout

```
.
├── flake.nix                          # inputs (stable + unstable) and host outputs
├── flake.lock                         # pinned input revisions (generated)
├── hosts/
│   └── vivobook-pro-15/
│       ├── default.nix                # host: imports hardware + modules, hostname, stateVersion
│       └── hardware-configuration.nix # machine-specific (you provide this)
└── modules/
    └── nixos/
        ├── default.nix                # imports every module below
        ├── audio.nix                  # pipewire
        ├── biometrics.nix             # howdy face login + PAM
        ├── boot.nix                   # bootloader, plymouth
        ├── desktop.nix                # greetd/niri, fonts, dconf, desktop integration
        ├── hardware.nix               # graphics/nvidia, bluetooth, power, wakeup quirk
        ├── locale.nix                 # timezone + locale
        ├── networking.nix             # NetworkManager
        ├── nix.nix                    # nix settings, gc, auto-upgrade
        ├── overlays.nix               # unstable channel as pkgs.unstable, steam tweak
        ├── packages.nix               # environment.systemPackages
        ├── programs.nix               # nix-ld, shell/dev tools, gnupg, steam, gamemode
        ├── services.nix               # printing, avahi, gvfs, flatpak
        ├── users.nix                  # user account
        └── virtualisation.nix         # podman, libvirtd, virt-manager
```

## First-time setup

1. Clone this repo:

   ```sh
   git clone https://github.com/megabyte6/dotfiles.git
   ```

2. Copy in your machine's hardware configuration, replacing `{hostname}` with the hostname of the machine you'd like to select:

   ```sh
   cp /etc/nixos/hardware-configuration.nix ~/dotfiles/hosts/{hostname}/hardware-configuration.nix
   ```

3. Stage the files and update the lock file:

   ```sh
   git add -A
   nix flake update    # generates flake.lock
   ```

   Inputs must be tracked by git for the flake to see them, so `git add -A` before building.

## Applying changes

Replace `{hostname}` with the hostname of your system.

```sh
sudo nixos-rebuild switch --flake ~/dotfiles#{hostname}
```

## Updating packages

Version bumps are handled by a GitHub Actions workflow daily. `system.autoUpgrade` rebuilds from the remote flake on a schedule. This means that there is little for you to do. If you wish to update manually, use the following commands, replacing `{hostname}` with the hostname of your system:

```sh
nix flake update                 # refresh all inputs
nix flake update nixpkgs         # or just one input
sudo nixos-rebuild switch --flake ~/dotfiles#{hostname}
```

Note that the hostname/system specifier can be left out if it is the same as the current generation's hostname.

## Formatting

```sh
nix fmt .
```

It is configured to use the [alejandra formatter](https://github.com/kamadorueda/alejandra) in `flake.nix`.
