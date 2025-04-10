{...}:
{
  home.file."nvim" = {
      enable = false;	
      executable = true;
      recursive = true;
      source = dotfiles/.config/nvim;
      target = ".config/nvim";
    };
}
