{ config, pkgs, ... }:
{
  launchd.agents.jankyBorders = {
    enable = true;
    config = {
      ProgramArguments = [
        "/opt/homebrew/bin/borders"
        "active_color=0xff007aff"
        "inactive_color=0xff494d64"
        "width=8.0"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/jankyBorders.out.log";
      StandardErrorPath = "/tmp/jankyBorders.err.log";
    };
  };
}
