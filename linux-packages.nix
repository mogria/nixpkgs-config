{ pkgs, lib, ... }:

{
  home.packages = lib.mkIf pkgs.stdenv.isLinux (with pkgs; [
    /* system management utilities */
    iotop
    htop
    lsof
    ltrace
    utillinux
    inetutils

    /* programming utilities */
    gdb
    cmake
    gcc
    xsel # required by tmux for copy paste into X clipboard and for macos compatible pbcopy
  ]);

  systemd.user.startServices = pkgs.stdenv.isLinux;
}
