{ pkgs, lib, ... }:

{
  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];

  imports = [
    ./vim/neovim.nix
    ./direnv/direnv.nix
    ./git/git.nix
    ./zsh/zsh.nix
    ./fzf/fzf.nix
    ./tmux/tmux.nix
    ./linux-packages.nix
  ];

  home.packages = with pkgs; [
    /* shell environment programs */
    w3m

    /* generating tags for vim */
    universal-ctags
    cscope
    global

    /* shell utilities */
    jq
    ripgrep # used by the vim
    tree
    binutils
    moreutils
    coreutils
    utillinux
    fd
    exa
    netcat
    unrar
    man-pages
    gnumake
    gnused
    gnupg22
    gnutar

  ];

  programs.command-not-found.enable = true;
}
