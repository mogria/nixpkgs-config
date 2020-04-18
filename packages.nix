{ pkgs, lib, ... }:

{
  home.extraOutputsToInstall = [ "doc" "info" "man" "devdoc" ];

  imports = [
    ./vim/neovim.nix
    ./vim/vifm.nix
    ./vim/vimpager.nix
    ./direnv/direnv.nix
    ./git/git.nix
    ./zsh/zsh.nix
    ./fzf/fzf.nix
    ./tmux/tmux.nix
    ./ripgrep/ripgrep.nix
    ./linux-packages.nix
  ];

  home.packages = with pkgs; [
    /* shell environment programs */
    w3m

    /* basic shell and utilities */
    tree
    binutils
    moreutils
    coreutils
    findutils
    diffutils
    patchutils
    procps # for watch
    netcat
    zip
    unzip
    unrar
    man-pages
    gnumake
    gnused
    gnupg22
    gnutar
    less
    jq # parse/filter/format json
    q-text-as-data # `q`-cli tool: use sql to query csv/tsv files
    xsv # query csv files
    wget
    dos2unix

    dnsutils

    git
    git-hub
    entr
    fd
    exa

    /* LaTeX */
    pkgs.texlive.combined.scheme-full
    pandoc


  ];

  # programs.command-not-found.enable = true;
}
