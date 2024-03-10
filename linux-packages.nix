{ pkgs, lib, ... }:

{
  imports = [
    ./php.nix
  ];
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
    xsel # required by tmux for copy paste into X clipboard and for macos compatible pbcopy

    docker
    docker-compose

    appimagekit
    fuse
    fuse-common
    appimage-run

    patchelf

    cacert

    emscripten

    pdftk
  ]);

  systemd.user.startServices = pkgs.stdenv.isLinux;
}
