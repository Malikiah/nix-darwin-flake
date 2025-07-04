{ pkgs, ... }:
let 
  zsh-autosuggestions = "source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
  zsh-syntax-highlighting = "source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
  
  zshrc = builtins.readFile ../home/.config/zsh/zshrc;
  zshenv = builtins.readFile ../home/.config/zsh/zshenv;

  zshrc_full = zshrc + "\n" + zsh-autosuggestions + "\n" + zsh-syntax-highlighting;

in
{
  home.file."powerlevel10k" = {
    enable = false;
    executable = true;
    recursive = false;
    source = ../home/.config/zsh/p10k.zsh;
    target = ".config/zsh/p10k.zsh";
    };

  home.file."starship" = {
    enable = true;
    executable = true;
    recursive = false;
    source = ../home/.config/starship.toml;
    target = ".config/starship.toml";
    };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
        enable = true;
      };
    initExtra = zshrc;
#    initExtraFirst = ''
#      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
#      test -f ~/.config/zsh/p10k.zsh && source ~/.config/zsh/p10k.zsh
#      '';
#    envExtra = zshenv;
#    zplug = {
#      enable = true;
#      plugins = [
#      { 
#        name="romkatv/powerlevel10k";
#        tags = [ as:theme depth:1 ]; 
#      }

#      ];
#      };
    };

}
