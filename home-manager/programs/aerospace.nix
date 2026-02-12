{pkgs, lib, ...}:
{
  home.file."aerospace" = {
      enable = true;
      executable = true;
      recursive = false;
      source = ../home/.config/aerospace/aerospace.toml;
      target = ".config/aerospace/aerospace.toml";
    };

}
