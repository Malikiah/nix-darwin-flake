{config, pkgs, ...}:
{
  home.file."alacritty" = {
    enable = true;
    executable = true;
    recursive = true;
    source = dotfiles/.config/alacritty/alacritty.toml;
    target = ".config/alacritty/alacritty.toml";
  };
  
}

