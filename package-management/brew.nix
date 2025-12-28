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
      "pipx"
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
      "rust"
      "rustup"
      "python"
      "python@3.12"
      "mlx"
      "huggingface-cli"
      "cmake"
      "nmap"
      "butane"
      "helm"
      "kubectl"
      "go"
      "pv"
      "npm"
      # "koekeishiya/formulae/yabai"
      #"koekeishiya/formulae/skhd"
     ];

    taps = [
      "earthly/earthly"
      "FelixKratz/formulae"
      "hashicorp/tap"
      "puppetlabs/puppet"
      ];

    casks = [
      "motion"
      "heptabase"
      "openmtp"
      "drawio"
      "pycharm"
      "loom"
      "ledger-wallet"
      "postman"
      "1password"
      "tresorit"
      "nvidia-geforce-now"
      "brave-browser"
      "google-chrome"
      "macfuse"
      "rustrover"
      "ollama-app"
      "anythingllm"
      "anytype"
      "monero-wallet"
      "monitorcontrol"
      "alacritty"
      "font-hack-nerd-font"
      "little-snitch"
      "micro-snitch"
      "affinity-designer"
      "affinity-photo"
      "onlyoffice"
      "bitwarden"
      "mullvad-vpn"
      "mullvad-browser"
      "zen"
      "obsidian"
      "font-fontawesome"
      "font-awesome-terminal-fonts"
      "burp-suite"
      "native-access"
      "cryptomator"
      "splice"
      "ableton-live-suite@10"
      "ilok-license-manager"
      "android-file-transfer"
      "signal"
      "steam"
      "wireshark-app"
      "whisky"
      "discord"
      "utm"
      "crossover"
      "blockblock"
      #"knockknock"
      "taskexplorer"
      "reikey"
      "netiquette"
      "ransomwhere"
      "KextViewr"
    ];
  };
}
