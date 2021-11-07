{ pkgs, ... }:

# This file exists to make sure that the tray.target exists for this systemd user, because
# it's required by a few modules.
# It doesn't exist because I don't use the xsession options provided by home-manger, configure my X-Session via NixOS-Options.
# See: https://github.com/nix-community/home-manager/issues/2064
{
  systemd.user.targets.tray = {
    Unit = {
      Description = "Home Manager System Tray";
      Requires = [ "graphical-session-pre.target" ];
    };
  };
}
