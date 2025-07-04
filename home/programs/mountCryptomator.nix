{ config, pkgs, lib, ... }:

let
  # Use diskutil apfs list to get the UUID
  sonnetechUUID  = "CE901405-63A0-4187-B5FC-CF0DFA4D6CD5";
  sonnetechMountDirectory = "${config.home.homeDirectory}/Documents/Cryptomator/Sonnetech";
in
{

  launchd.agents.mountCryptomator = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.bash}/bin/bash"
        "-c"
        ''
        set -euo pipefail

        # 1.  Ensure the directory exists and is owned by you
        if [ ! -d "${sonnetechMountDirectory}" ]; then
          mkdir -p "${sonnetechMountDirectory}"
        fi
        
        /usr/sbin/diskutil mount readWrite \
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

