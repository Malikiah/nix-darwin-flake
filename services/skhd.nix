{pkgs, ...}:
let 
  terminal = "alt - return : open -na ${pkgs.alacritty}/Applications/Alacritty.app;";
  browser = "alt - b : open -na /Applications/Orion.app;";
  screenshot = "alt - s : skhd -k \"cmd + shift - 5\";";

  skhdrc-movement = builtins.readFile ../home/programs/dotfiles/config/skhd/skhdrc;

  skhdrc-applications = ''
    #Terminal
    ${terminal}

    #Browser
    ${browser}

    # Screenshot Utility
    # This is bound to what the default is in MacOS maintaing the ease
    # of use from one config file.
    ${screenshot}
  '';

  skhdrc = skhdrc-movement + skhdrc-applications;

in
{
    services.skhd = {
      enable = true;
      skhdConfig = ''
        ${skhdrc}
      '';
    };
}
