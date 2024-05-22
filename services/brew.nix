{...}: {
  homebrew = {
    enable = true;
    global = {
      brewfile = true;
    };
    brews = [
      "earthly"
    ];

    taps = [
      "cloudflare/cloudflare"
      "earthly/earthly"
      "homebrew/bundle"
      "homebrew/cask-fonts"
      "homebrew/services"
    ];
    casks = [
      "nikitabobko/tap/aerospace"
      "orion"
      "little-snitch"
      "micro-snitch"
      "launchbar"
      #"vmware-fusion"
      "affinity-designer"
      "affinity-photo"
      "nextcloud"
      "onlyoffice"
      "tuta-mail"
      "bitwarden"
      "mullvadvpn"
      "mullvad-browser"
      "obsidian"
      "burp-suite"
      "brave-browser"
      "native-access"
      "splice"
      "ableton-live-suite@10"
      "ilok-license-manager"
      "android-file-transfer"
      "steam"
      "arc"
    ];
  };
}
