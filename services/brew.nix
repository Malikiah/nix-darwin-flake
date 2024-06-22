{...}: {
  homebrew = {
    enable = true;
    brewPrefix = "/opt/homebrew/bin";
    global = {
      brewfile = true;
    };

    brews = [
      "zsh"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
      "neovim"
      "molten-vk"
      "openvpn"
      "ansible"
      "git"
      "git-lfs"
      "borders"
      "jakehilborn/jakehilborn/displayplacer"
      "qemu"
      "7zip"
      "koekeishiya/formulae/yabai"
      "koekeishiya/formulae/skhd"
     ];

    taps = [
      "homebrew/bundle"
      "homebrew/cask-fonts"
      "homebrew/services"
      "cloudflare/cloudflare"
      "earthly/earthly"
      "FelixKratz/formulae"
      ];

    casks = [
     # "nikitabobko/tap/aerospace"
      "monitorcontrol"
      "alacritty"
      "little-snitch"
      "micro-snitch"
      "launchbar"
      "vmware-fusion"
      "affinity-designer"
      "affinity-photo"
      "nextcloud"
      "onlyoffice"
      "tuta-mail"
      "bitwarden"
      "mullvadvpn"
      "mullvad-browser"
      "firefox"
      "obsidian"
      "burp-suite"
      "brave-browser"
      "native-access"
      "splice"
      "ableton-live-suite@10"
      "ilok-license-manager"
      "android-file-transfer"
      "steam"
      "wireshark"
      "arc"
      "whisky"
      "discord"
      "utm"
      "crossover"
      "blockblock"
      "knockknock"
      "do-not-disturb"
      "taskexplorer"
      "reikey"
      "netiquette"
      "ransomwhere"
      "KextViewr"
      "whatsyoursign"
    ];
  };
}
