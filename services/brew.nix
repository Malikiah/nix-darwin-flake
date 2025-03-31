{...}: {
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      upgrade = true;
    };

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
      "qemu"
      "7zip"
      "rustup"
      "python"
      # "koekeishiya/formulae/yabai"
      #"koekeishiya/formulae/skhd"
     ];

    taps = [
      "earthly/earthly"
      "FelixKratz/formulae"
      ];

    casks = [
      "dropbox"
      "rustrover"
      "ollama"
      "anythingllm"
      "anytype"
#      "nikitabobko/tap/aerospace"
      "monero-wallet"
      "monitorcontrol"
      "alacritty"
      "font-hack-nerd-font"
      "little-snitch"
      "micro-snitch"
      "launchbar"
      "affinity-designer"
      "affinity-photo"
      "onlyoffice"
      "tuta-mail"
      "bitwarden"
      "mullvadvpn"
      "mullvad-browser"
      "zen-browser"
      "tor-browser"
      "obsidian"
      "font-fontawesome"
      "font-awesome-terminal-fonts"
      "burp-suite"
      "brave-browser"
      "native-access"
      "filen"
      "cryptomator"
      "splice"
      "ableton-live-suite@10"
      "ilok-license-manager"
      "android-file-transfer"
      "signal"
      "steam"
      "wireshark"
      "whisky"
      "discord"
      "utm"
      "crossover"
      "blockblock"
      "knockknock"
      "taskexplorer"
      "reikey"
      "netiquette"
      "ransomwhere"
      "KextViewr"
      "whatsyoursign"
      "notchnook"
    ];
  };
}
