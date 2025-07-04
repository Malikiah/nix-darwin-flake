{pkgs, lib, ...}:
{
  home.file."skhd" = {
      enable = true;
      executable = true;
      recursive = true;
      source = ../home/.config/skhd/skhdrc;
      target = ".config/skhd/skhdrc";
    };
  }

