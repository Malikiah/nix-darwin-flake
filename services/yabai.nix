{...}:
let
#  yabairc = builtins.readFile ../home-manager/programs/dotfiles/.config/yabai/yabairc;

in 
{
    services.yabai = {
      enable = true;
      enableScriptingAddition = true;
#      extraConfig = ''
#        ${yabairc}  
#      '';
    };
}
