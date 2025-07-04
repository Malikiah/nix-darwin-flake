{ config, pkgs, ... }:
{
  launchd.agents.monitorControl = {
    enable = true;
    config = {
      ProgramArguments = [
        "open -na ${pkgs.monitorcontrol}/Applications/MonitorControl.app"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/monitorControl.out.log";
      StandardErrorPath = "/tmp/monitorControl.err.log";
    };
  };
}
