{pkgs, ...}:
{
    services."monitorcontrol" = {
        enable = true;
        script = ''
          /Applications/Home\ Manager\ Apps/MonitorControl.app
        '';
      };
  }
