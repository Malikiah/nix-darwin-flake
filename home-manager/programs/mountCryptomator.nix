{ config, pkgs, lib, ... }:

let
  # Use diskutil apfs list to get the UUID
  sonnetechUUID  = "CE901405-63A0-4187-B5FC-CF0DFA4D6CD5";
  sonnetechMountDirectory = "${config.home.homeDirectory}/Documents/Encrypted\ Volumes/Sonnetech";
in
{
  home.file."cryptmator" = {
    enable = true;
    executable = true;
    recursive = true;
    source = ../home/Library/Application Support/Cryptomator;
    target = "Library/Application Support/Cryptomator";
  };


  launchd.agents.mountCryptomator = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.bash}/bin/bash"
        "-c"
        ''
        set -euo pipefail

        if [ ! -d "${sonnetechMountDirectory}" ]; then
          mkdir -p "${sonnetechMountDirectory}"
        fi

        ${pkgs.bash}/usr/sbin/diskutil unmount ${sonnetechUUID}

        ${pkgs.bash}/usr/sbin/diskutil mount \
          -mountPoint '${sonnetechMountDirectory}' \
          ${sonnetechUUID}
            
        ''
      ];
      WatchPaths = [ "/Volumes" ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath  = "/tmp/mountCryptomator.out.log";
      StandardErrorPath = "/tmp/mountCryptomator.err.log";
    };
  };
}

