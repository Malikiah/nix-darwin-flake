{pkgs, ...}:
{
    services.skhd = {
      enable = false;
    };

    launchd.user.agents."org.nixos.skhd".serviceConfig = {
      StandardOutPath = "/tmp/skhd.out.log";
      StandardErrorPath = "/tmp/skhd.err.log";
    };
}
