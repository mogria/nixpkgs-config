{ pkgs, lib, ... }:

{
  home.extraOutputsToInstall = [ "doc" "info" "man" "devdoc" ];

  imports = [
    ./vim/neovim.nix
    ./vim/vimpager.nix
    ./direnv/direnv.nix
    ./git/git.nix
    ./zsh/zsh.nix
    ./bash/bash.nix
    ./fzf/fzf.nix
    ./tmux/tmux.nix
    ./ripgrep/ripgrep.nix
    ./linux-packages.nix
    ./ssh/ssh.nix
   #  ./dwm/dwm.nix
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
    stow
    gnused
    gnupg
    gnutar
    less
    jq # parse/filter/format json
    q-text-as-data # `q`-cli tool: use sql to query csv/tsv files
    xsv # query csv files
    wget
    dos2unix
    rsync

    dnsutils

    git
    tea
    entr
    fd  # find replacement
    eza # ls replacement
    bat # cat replacement, aliases to p

    /* LaTeX */
    pkgs.texlive.combined.scheme-full
    pandoc


    # backup tool
    duplicity

    # development tools
    nur.repos.kalbasit.nixify
  ];

  # programs.command-not-found.enable = true;
}
