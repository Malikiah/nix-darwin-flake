{ config, pkgs, lib, ... }:

let
  # Use diskutil apfs list to get the UUID
  sonnetechUUID  = "CE901405-63A0-4187-B5FC-CF0DFA4D6CD5";
  sonnetechMountPoint = "${config.home.homeDirectory}/Documents/Tresorit/Encrypted Volumes/Sonnetech";
  script = pkgs.writeShellScript "mountCryptomator" ''
    while true; do
        if [ ! -d "${sonnetechMountPoint}" ]; then
          mkdir -p "${sonnetechMountPoint}"
        fi

        currentMountPoint=$(diskutil info ${sonnetechUUID} | grep "Mount Point:" | awk -F":" '{print $2}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

        if [ "''${currentMountPoint}" != "${sonnetechMountPoint}" ]; then


          echo "$(date) Remounting Sonnetech..."
          /usr/sbin/diskutil unmount '${sonnetechUUID}'

          /usr/sbin/diskutil mount -mountPoint '${sonnetechMountPoint}' '${sonnetechUUID}'

        else
          sleep 10
        fi

    done 
  '';
in
{
  launchd.agents.mountSonnetech = {
    enable = true;
    config = {
      ProgramArguments = [ script.outPath ];
      #WatchPaths = [ "/Volumes" ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath  = "/tmp/mountCryptomator.out.log";
      StandardErrorPath = "/tmp/mountCryptomator.err.log";
    };
  };
}

