{config, pkgs, darwinPackages, ...}:
{
  programs.home-manager.enable = true;

  imports = [
    ./programs/aerospace.nix
    ./programs/alacritty.nix
    ./programs/yabai.nix
    ./programs/skhd.nix
    ./programs/zsh.nix
    ./programs/nvim.nix
    ./programs/mountSonnetech.nix
    ./programs/jankyBorders.nix
    ./programs/monitorControl.nix
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

}
