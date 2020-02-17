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

    /* shell utilities */
    tree
    binutils
    moreutils
    coreutils
    findutils
    diffutils
    patchutils
    netcat
    unrar
    man-pages
    gnumake
    gnused
    gnupg22
    gnutar
    less
    jq
    wget
    dos2unix

    dnsutils

    git
    git-hub
    entr
    fd
    exa
    ripgrep
  ];

  programs.command-not-found.enable = true;
}
