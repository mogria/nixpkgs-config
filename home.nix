{ pkgs, ... }:

let
  config = import ./user-config.nix;
  stdenv = pkgs.stdenv;
  fetchgit = pkgs.fetchgit;
in {
  imports = [
    ./vim/neovim.nix
    ./direnv/direnv.nix
    ./git/git.nix
    ./zsh/zsh.nix
    ./fzf/fzf.nix
    ./tmux/tmux.nix
    ./services/dropbox.nix
    ./graphical/packages.nix
  ];
  programs.home-manager = {
    enable = true;
  } // (if config.homemanager.development then {
    path = "${config.getDirectory "code"}/home-manager";
  } else {});

  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];
  home.packages = [
    /* shell environment programs */
    pkgs.w3m

    /* zsh, direnv is already included */
    pkgs.universal-ctags
    pkgs.cscope
    pkgs.global

    /* shell utilities */
    pkgs.jq
    pkgs.ripgrep # used by the vim
    pkgs.tree
    pkgs.binutils
    pkgs.moreutils
    pkgs.coreutils
    pkgs.utillinux
    pkgs.fd
    pkgs.exa
    pkgs.netcat
    pkgs.unrar
    pkgs.man-pages

    /* system management utilities */
    pkgs.iotop
    pkgs.htop
    pkgs.lsof
    pkgs.ltrace


    /* programming utilities */
    pkgs.gdb
    pkgs.gcc
    pkgs.gnumake
    pkgs.cmake
  ];

  home.file."bin/" = {
    executable = true;
    source = ./bin;
  };

  programs.command-not-found.enable = true;

  systemd.user.startServices = pkgs.stdenv.isLinux;
}
