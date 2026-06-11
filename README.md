# nix-darwin-flake

A declarative macOS (Apple Silicon) system configuration built on
[nix-darwin](https://github.com/LnL7/nix-darwin) + flakes, with
[home-manager](https://github.com/nix-community/home-manager) for the user
environment and [Homebrew](https://brew.sh) for casks/apps that Nix doesn't
cover. Everything below — system defaults, packages, services, and dotfiles —
is reproducible from this repo.

## What this flake configures

- **System defaults** ([`darwin-configuration.nix`](darwin-configuration.nix)) —
  Dock, Finder, screenshots, firewall (`alf`), Control Center, login window,
  accessibility, and other `system.defaults` settings, plus a `macintosh`
  host with `aarch64-darwin` as the platform.
- **Packages** — system packages via Nix, Homebrew casks/formulae via
  [`package-management/brew.nix`](package-management/brew.nix), and custom
  derivations under [`package-management/packages/`](package-management/packages).
- **Services** ([`services/`](services)) — window management and hotkeys:
  [`yabai.nix`](services/yabai.nix), [`skhd.nix`](services/skhd.nix), and
  (optional) [`monitorcontrol.nix`](services/monitorcontrol.nix).
- **User environment** ([`home-manager/`](home-manager)) — per-user programs and
  dotfiles (Alacritty, Neovim, Zsh, Aerospace, JankyBorders, etc.) for the
  `default` user.

The flake exposes a single system output, `darwinConfigurations."macintosh"`,
which is what `darwin-rebuild` builds and activates.

## Pre Configuration

Before running the installation you must allow Full Disk access to the terminal you will be installing with

`System Settings -> Privacy & Security -> Full Disk Access`

```bash
curl https://raw.githubusercontent.com/Malikiah/nix-darwin-flake/refs/heads/main/nix-darwin-installer.sh | sh
```

Disable SIP for Yabai
https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection

```bash
csrutil enable --without fs --without debug --without nvram
```

Then run the following and reboot
```bash
sudo nvram boot-args=-arm64e_preview_abi
```

lastly run, this is necessary to get Yabai to work properly. We are adding the yabai scripting aditions. 
```bash
sudo yabai --load-sa
```

## What the installer script does

[`nix-darwin-installer.sh`](nix-darwin-installer.sh) bootstraps a fresh Mac (or
repairs a broken one). It is **idempotent** — every component is independently
validated and only installed when it's actually missing, so re-running it fills
in whatever got corrupted rather than assuming the machine is already set up.
In order, it:

1. **Checks it's macOS** and re-execs under `bash` if launched by a non-bash shell.
2. **Sets the machine identity** — `ComputerName`, `HostName`, `LocalHostName` → `macintosh`.
3. **Ensures Nix** is installed (via the Determinate Systems installer) and
   loads it into the current shell.
4. **Ensures flakes are enabled** in `~/.config/nix/nix.conf`.
5. **Ensures Homebrew** is installed (non-interactively) and on `PATH`.
6. **Ensures Rosetta 2** on Apple Silicon (skipped on Intel).
7. **Ensures Xcode Command Line Tools** (needed for `git`).
8. **Ensures the flake repo** exists at `/etc/nix-darwin` — if a config is
   already there, it is **left untouched** (no clone, overwrite, or chown);
   only a truly empty target is cloned fresh.
9. **Preflight validation** — confirms every piece above is present before
   continuing, and fails loudly (telling you to re-run) if anything is missing.
10. **Builds and activates** the config with `darwin-rebuild switch`
    (bootstrapping via `nix run nix-darwin` if `darwin-rebuild` isn't present yet).

Then reboot.

## Apply Nix Flake

Apply the configuration after editing any `.nix` file:

```bash
darwin-rebuild switch
```

If you're running it from outside the repo directory, point it at the flake:

```bash
darwin-rebuild switch --flake /etc/nix-darwin#macintosh
```

## Maintaining the flake

| Command | What it does |
| --- | --- |
| `darwin-rebuild switch` | Build the config and activate it now. |
| `darwin-rebuild build` | Build only — produces `./result` without activating (good for testing changes). |
| `darwin-rebuild check` | Build and run the activation checks without switching. |
| `nix flake update` | Update **all** inputs and rewrite `flake.lock`. |
| `nix flake update nixpkgs` | Update a single input (e.g. just `nixpkgs`). |
| `nix flake metadata` | Show inputs and their locked revisions. |
| `darwin-rebuild changelog` | Show the nix-darwin changelog (read before bumping `system.stateVersion`). |
| `nix-collect-garbage -d` | Delete old generations and free disk space. |
| `darwin-rebuild --list-generations` | List previous system generations. |
| `darwin-rebuild switch --rollback` | Roll back to the previous generation if a switch broke something. |

Typical update flow:

```bash
nix flake update      # bump inputs
darwin-rebuild switch  # rebuild and activate
```

### Searching for packages

```bash
nix-env -qaP | grep <name>          # search nixpkgs
nix search nixpkgs <name>           # flake-style search
```

- Add **Nix** packages to `environment.systemPackages` in
  [`darwin-configuration.nix`](darwin-configuration.nix), or to a home-manager
  module for user-scoped tools.
- Add **Homebrew** casks/formulae in
  [`package-management/brew.nix`](package-management/brew.nix).

After any change, run `darwin-rebuild switch` to apply it.
