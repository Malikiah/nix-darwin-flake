{...}:
{
  home.file."nvim" = {
      enable = true;	
      executable = true;
      recursive = true;
      source = ../home/.config/nvim;
      target = ".config/nvim";
    };
}
