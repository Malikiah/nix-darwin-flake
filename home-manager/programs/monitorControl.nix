{ config, pkgs, ... }:
let
  script = pkgs.writeShellScript "monitorcontrol-wrapper" ''
    while true; do
      open -a "${pkgs.monitorcontrol}/Applications/MonitorControl.app"
      while pgrep -f "MonitorControl.app" > /dev/null; do
        sleep 5
      done
      echo "MonitorControl crashed or quit... restarting in 2s"
      sleep 2
    done
  '';
in 
{
  launchd.agents.monitorControl = {
    enable = false;
    config = {
      ProgramArguments = [ script.outPath ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/monitorControl.out.log";
      StandardErrorPath = "/tmp/monitorControl.err.log";
    };
  };
}
