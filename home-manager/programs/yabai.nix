{pkgs, lib, ...}:
{
  home.file."yabai" = {
      enable = true;
      executable = true;
      recursive = true;
      source = ../home/.config/yabai/yabairc;
      target = ".config/yabai/yabairc";
    };


  home.file."skhd" = {
      enable = true;
      executable = true;
      recursive = true;
      source = ../home/.config/skhd/skhdrc;
      target = ".config/skhd/skhdrc";
    };
  }
