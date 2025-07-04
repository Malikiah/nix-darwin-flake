{ config, pkgs, lib, ... }:

let
  # Use diskutil apfs list to get the UUID
  sonnetechUUID  = "CE901405-63A0-4187-B5FC-CF0DFA4D6CD5";
  sonnetechMountDirectory = "${config.home.homeDirectory}/Documents/Encrypted\ Volumes/Sonnetech";
  cryptomatorSettings = ''
  {
    "directories" : [ {
      "id" : "nuMcJxlr9LR-",
      "path" : "${config.home.homeDirectory}/Documents/Encrypted Volumes/Local",
      "displayName" : "Local",
      "unlockAfterStartup" : true,
      "revealAfterMount" : true,
      "mountPoint" : "${config.home.homeDirectory}/Documents/Personal Volumes/Local",
      "usesReadOnlyMode" : false,
      "mountFlags" : "-orw,exec,uid=501,gid=20",
      "maxCleartextFilenameLength" : 2147483647,
      "actionAfterUnlock" : "IGNORE",
      "autoLockWhenIdle" : false,
      "autoLockIdleSeconds" : 1800,
      "mountService" : "org.cryptomator.frontend.fuse.mount.MacFuseMountProvider",
      "port" : 42427
    }, {
      "id" : "is1d_vLMcGbC",
      "path" : "${config.home.homeDirectory}/Documents/Encrypted Volumes/Sonnetech",
      "displayName" : "Sonnetech",
      "unlockAfterStartup" : true,
      "revealAfterMount" : true,
      "mountPoint" : "${config.home.homeDirectory}/Documents/Personal Volumes/Sonnetech",
      "usesReadOnlyMode" : false,
      "mountFlags" : "-orw,exec,uid=501,gid=20",
      "maxCleartextFilenameLength" : 2147483647,
      "actionAfterUnlock" : "IGNORE",
      "autoLockWhenIdle" : false,
      "autoLockIdleSeconds" : 1800,
      "port" : 42427
    } ],
    "writtenByVersion" : "1.15.2-dmg-5577",
    "autoCloseVaults" : true,
    "debugMode" : false,
    "theme" : "LIGHT",
    "keychainProvider" : "org.cryptomator.macos.keychain.MacSystemKeychainAccess",
    "mountService" : "org.cryptomator.frontend.fuse.mount.MacFuseMountProvider",
    "numTrayNotifications" : 3,
    "port" : 42427,
    "showTrayIcon" : true,
    "compactMode" : false,
    "startHidden" : true,
    "uiOrientation" : "LEFT_TO_RIGHT",
    "useKeychain" : true,
    "windowHeight" : 1391,
    "windowWidth" : 1262,
    "windowXPosition" : 2572,
    "windowYPosition" : 37,
    "checkForUpdatesEnabled" : true,
    "lastReminderForUpdateCheck" : "2025-03-31T05:15:00Z",
    "lastSuccessfulUpdateCheck" : "2025-07-04T04:42:09Z",
    "useQuickAccess" : true
  }
  '';
in
{
  home.file."cryptmator" = {
    enable = true;
    executable = true;
    recursive = true;
    text = cryptomatorSettings;
    #source = ../home/Library/Application Support/Cryptomator;
    target = "Library/Application Support/Cryptomator/settings.json";
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

