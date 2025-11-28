{pkgs, ...}:
{
    services.skhd = {
      enable = true;
    };

    launchd.user.agents."org.nixos.skhd".serviceConfig = {
      StandardOutPath = "/tmp/skhd.out.log";
      StandardErrorPath = "/tmp/skhd.err.log";
    };
}
