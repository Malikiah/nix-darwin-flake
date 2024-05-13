{pkgs, ...}:
{
    security.sudo.extraConfig = ''
      default ALL = (root) NOPASSWD: ${pkgs.yabai}/bin/yabai --load-sa
    '';
  }
