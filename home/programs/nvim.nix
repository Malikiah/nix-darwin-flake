{...}:
{
  home.file."nvim" = {
      enable = true;	
      executable = true;
      recursive = true;
      source = "~/dotfiles/.config/nvim";
      target = ".config/nvim";
    };
}
