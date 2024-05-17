{config, pkgs, ...}:
{
  programs.home-manager.enable = true;

  imports = [
    ./programs/aerospace.nix
    ./programs/alacritty.nix
#    ./programs/yabai.nix
    ./programs/zsh.nix
    ./programs/nvim.nix
  ];
  home.username = "default";
  home.stateVersion = "23.11";
  home.packages = [
    pkgs.alacritty
    pkgs.git
    pkgs.monitorcontrol
    pkgs.zsh
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
    pkgs.wireshark
    pkgs.jankyborders
    #pkgs.zsh-powerlevel10k
  ];
  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    EDITOR = "nvim";

  };

}
