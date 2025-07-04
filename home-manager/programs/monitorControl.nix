{ config, pkgs, ... }:
let
  script = pkgs.writeShellScript "monitorcontrol-wrapper" ''
    while true; do
      open -a "/Applications/MonitorControl.app"
      while pgrep -f "MonitorControl.app" > /dev/null; do
        sleep 5
      done
      echo "MonitorControl crashed or quit... restarting in 2s"
      sleep 2
    done
  '';
in 
{
  home.file."monitorcontrol" = {
      enable = true;
      executable = true;
      recursive = true;
      source = ../home/Library/Preferences/app.monitorcontrol.MonitorControl.plist;
      target = "./Library/Preferences/app.monitorcontrol.MonitorControl.plist";
    };

  launchd.agents.monitorControl = {
    enable = true;
    config = {
      ProgramArguments = [ script.outPath ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/monitorControl.out.log";
      StandardErrorPath = "/tmp/monitorControl.err.log";
    };
  };
}
