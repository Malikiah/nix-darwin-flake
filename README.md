# Pre Configuration
Before running the installation you must allow Full Disk access to the terminal you will be installing with\n

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

# Apply Nix Flake
```bash
darwin-rebuild switch
```
