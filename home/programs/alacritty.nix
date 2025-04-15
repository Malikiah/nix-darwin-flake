{config, pkgs, ...}:
{
  home.file."alacritty" = {
    enable = true;
    executable = true;
    recursive = true;
    source = "/Users/default/dotfiles/.config/alacritty";
    target = ".config/alacritty";
  };
  
}

