{
  description = "Darwin System Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ...}:
  let
    # Resolve the username at evaluation time so the config follows whoever runs
    # the rebuild instead of being pinned to "default". This reads the
    # environment, so builds must pass --impure (the installer and the README
    # alias both do). Prefer SUDO_USER because `darwin-rebuild` runs under sudo,
    # where $USER would otherwise be "root". Falls back to "default".
    username =
      let
        sudoUser = builtins.getEnv "SUDO_USER";
        envUser = builtins.getEnv "USER";
      in
        if sudoUser != "" then sudoUser
        else if envUser != "" && envUser != "root" then envUser
        else "default";
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild switch --flake .#macintosh
    #
    # "macintosh" is just the configuration name. To rename it, change the
    # attribute name below (e.g. darwinConfigurations."mymac") and use the new
    # name everywhere it appears: the darwinPackages line at the bottom, the
    # --flake .#<name> argument, and the scutil host names in
    # nix-darwin-installer.sh. If your machine's hostname matches the name you
    # can also just run `darwin-rebuild switch` with no --flake argument.
    darwinConfigurations."macintosh" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      # Make `username` available to ./darwin-configuration.nix.
      specialArgs = { inherit username; };
      modules = [
      ./darwin-configuration.nix
 #     ./security.nix
      home-manager.darwinModules.home-manager{
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # Make `username` available to the home-manager modules too.
          home-manager.extraSpecialArgs = { inherit username; };
          home-manager.users.${username} = import home-manager/configuration.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."macintosh".pkgs;
  };
}
