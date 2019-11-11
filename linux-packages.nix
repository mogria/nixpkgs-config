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
  ]);

  systemd.user.startServices = lib.mkIf pkgs.stdenv.isLinux;
}
