{ pkgs, lib, ... }:

{
  home.packages = lib.mkIf pkgs.stdenv.isLinux (with pkgs; [
    /* system management utilities */
    pkgs.iotop
    pkgs.htop
    pkgs.lsof
    pkgs.ltrace

    /* programming utilities */
    pkgs.gdb
    pkgs.gcc
    pkgs.cmake


    pkgs.xsel # required by tmux for copy paste into X clipboard and for macos compatible pbcopy
  ]);

  systemd.user.startServices = lib.mkIf pkgs.stdenv.isLinux;
}
