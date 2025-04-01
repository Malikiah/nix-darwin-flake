{pkgs, lib, ...}:
{
  home.file."yabai" = {
      enable = true;
      executable = true;
      recursive = true;
      source = dotfiles/.config/yabai/yabairc;
      target = ".config/yabai/yabairc";
    };


  home.file."skhd" = {
      enable = true;
      executable = true;
      recursive = true;
      source = dotfiles/.config/skhd/skhdrc;
      target = ".config/skhd/skhdrc";
    };
  }
