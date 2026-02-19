#https://nix-darwin.github.io/nix-darwin/manual/index.html
{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./package-management/brew.nix
    ./services/yabai.nix
    ./services/skhd.nix
    #./services/monitorcontrol.nix
  ];
  #services.nix-daemon.enable = true;
  nix.enable = false;
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [ 
#    pkgs.terraform
    ];

  # Auto upgrade nix package and the daemon service.
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
#  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  ids.gids.nixbld = 350;


  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  users.users.default.home = "/Users/default";

  system.defaults = {
    WindowManager.StandardHideDesktopIcons = true;
    # Disabled for Yabai
    WindowManager.EnableStandardClickToShowDesktop = false;

    NSGlobalDomain = {
      "com.apple.swipescrolldirection" = false;
      "com.apple.sound.beep.feedback" = 0; # Disable Feedback noises
      "com.apple.sound.beep.volume" = 0.0; # Turns Volume of beep to 0
    };


    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";


    screencapture.location = "~/Pictures/screenshots";

    screensaver.askForPasswordDelay = 10;

    alf= {
      globalstate = 1;
      loggingenabled = 1;
      stealthenabled = 1;
    };
    
    controlcenter = {
      AirDrop = false;
      BatteryShowPercentage = false;
      Bluetooth = false;
      Sound = false;
    };
    
    loginwindow = {
      GuestEnabled = false;
    };

    universalaccess = {
      reduceTransparency = true;
      reduceMotion = true;
    };  

    spaces = {
        spans-displays = false;
    };

    dock.autohide = true;
    dock.mru-spaces = false;
    dock.persistent-apps = [
      {
        app = "/Applications/Zen.app";
      }
      {
        app = "/Applications/Heptabase.app";
      }
      {
        app = "/Applications/1Password.app";
      }
    ];


  };
}
