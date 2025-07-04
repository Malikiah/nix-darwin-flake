{config, pkgs, ...}:
{
  home.file."alacritty" = {
    enable = true;
    executable = true;
    recursive = true;
    source = ../home/.config/alacritty;
    target = ".config/alacritty";
  };
  
}

