{config, pkgs, darwinPackages, ...}:
{
  programs.home-manager.enable = true;

  imports = [
    ./programs/aerospace.nix
    ./programs/alacritty.nix
    ./programs/yabai.nix
    ./programs/zsh.nix
    ./programs/nvim.nix
  ];
  home.username = "default";
  home.stateVersion = "24.11";
  home.packages = [
    #pkgs.zsh-autosuggestions
    #pkgs.zsh-syntax-highlighting
    #pkgs.jankyborders
    #pkgs.darwin.moltenvk
    #pkgs.zsh-powerlevel10k
  ];
  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    EDITOR = "nvim";

  };

  launchd.agents.jankyBorders = {
    enable = true;
    config = {
      ProgramArguments = [
        "/opt/homebrew/bin/borders"
        "active_color=0xff007aff"
        "inactive_color=0xff494d64"
        "width=6.0"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/jankyborders.out.log";
      StandardErrorPath = "/tmp/jankyborders.err.log";
    };
  };
}
