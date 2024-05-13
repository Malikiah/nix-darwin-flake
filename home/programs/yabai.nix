{pkgs, lib, ...}:
let
  terminal = "alt - return : open -na ${pkgs.alacritty}/Applications/Alacritty.app;";
  browser = "alt - b : open -na /Applications/Orion.app;";

  skhdrc-movement = builtins.readFile dotfiles/config/skhd/skhdrc;

  skhdrc-applications = ''
    #Terminal
    ${terminal}

    #Browser
    ${browser}
  '';

  skhdrc = skhdrc-movement + skhdrc-applications;
  
in 
{
  home.file."yabai" = {
      enable = true;
      executable = true;
      recursive = false;
      source = dotfiles/config/yabai/yabairc;
      target = ".config/yabai/yabairc";
    };


  home.file."skhd" = {
      enable = true;
      executable = true;
      recursive = false;
      text = skhdrc;
      target = ".config/skhd/skhdrc";
    };
  }
