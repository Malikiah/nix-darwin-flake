{ config, pkgs, lib, ... }:

let
  sonnetechUUID  = "0E239BC6-F960-3107-89CF-1C97F78BB46B";
  sonnetechMountDirectory = "${config.home.homeDirectory}/Documents/Cryptomator/Sonnetech";
in
{
  # Same directory-creation trick, but in the *home* activation script

  launchd.agents.mountCryptomator = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/bash"
        "-c"
        "'/Users/default/test_script'"
      ];
      WatchPaths = [ "/Volumes" ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath  = "/tmp/mountCryptomator.out.log";
      StandardErrorPath = "/tmp/mountCryptomator.err.log";
    };
  };
}

