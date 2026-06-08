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

1. Put this repo at `~/dotfiles` (the auto-upgrade path in `modules/nixos/nix.nix` expects it there — adjust if you use a different location).

2. Copy in your machine's hardware configuration:

   ```sh
   cp /etc/nixos/hardware-configuration.nix \
      ~/dotfiles/hosts/vivobook-pro-15/hardware-configuration.nix
   ```

3. Initialise the repo and create the lock file:

   ```sh
   cd ~/dotfiles
   git init && git add -A
   nix flake update    # generates flake.lock
   ```

   Inputs must be tracked by git for the flake to see them, so `git add -A` before building.

## Applying changes

```sh
sudo nixos-rebuild switch --flake ~/dotfiles#vivobook-pro-15
```

## Updating packages

```sh
nix flake update                 # refresh all inputs
nix flake update nixpkgs         # or just one input
sudo nixos-rebuild switch --flake ~/dotfiles#vivobook-pro-15
```

`system.autoUpgrade` rebuilds from this flake on a schedule and bumps inputs on its own. If you decide you don't want this feature, comment out `--recreate-lock-file` in `modules/nixos/nix.nix`. Doing so will require you to manually run `nix flake update` to pull newer package versions.

## Formatting

```sh
nix fmt
```

It is configured to use the [alejandra formatter](https://github.com/kamadorueda/alejandra) in `flake.nix`.
