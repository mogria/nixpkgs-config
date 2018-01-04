{ pkgs, ... }:

let
  stdenv = pkgs.stdenv;
  fetchgit = pkgs.fetchgit;
  powerlevel9k = stdenv.mkDerivation rec {
    name = "zsh-powerlevel9k";
    version = "0.6.3";
    src = fetchgit {
      url = "https://github.com/bhilburn/powerlevel9k";
      rev = "refs/tags/v0.6.3";
      sha256 = "02c1yrr1cc5q51bzg83gyg9pqsx5im30hcvrqyh9mbpmibf6cr2p";
    };
    installPhase = ''
      mkdir -p $out/share/powerlevel9k
      cp -R functions $out/share/powerlevel9k
      cp powerlevel9k.zsh-theme $out/share/powerlevel9k
    '';
  };
in {
  programs.home-manager.enable = true;
  programs.home-manager.path = "https://github.com/mogria/home-manager/archive/master.tar.gz";

  home.packages = [
    pkgs.gnome3.gnome_terminal
    pkgs.jq
    pkgs.tree
    pkgs.dropbox
    pkgs.keepassx

    pkgs.iotop
    pkgs.htop

    pkgs.direnv
  ];

  programs.rofi.enable = true;

  programs.git = {
    enable = true;
    userName = "Mogria";
    userEmail = "m0gr14@gmail.com";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    shellAliases = {
      "vi" = "vim";
      "ll" = "ls -lAtr";
      "gs" = "git status";
      "ga" = "git add";
      "gc" = "git commit";
      "gd" = "git diff";
      "gp" = "git push";
      # make alias expansion work with the following commands as prefix
      "xargs" = "xargs ";
      "sudo" = "sudo ";
    };
    history = {
      ignoreDups = true;
      share = true;
    };
    initExtra = ''
      eval "$(direnv hook zsh)"
      export EDITOR=vi
      export VISUAL=vim

      if [ -e "$HOME/.zinputrc" ]; then
          source "$HOME/.zinputrc"
      fi

      export TERM="xterm-256color"
      export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
      plugins=(git dircycle composer)

      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(command_execution_time status root_indicator)
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(dir vcs)
      POWERLEVEL9K_STATUS_VERBOSE=true
      # ugly hack: oh my zsh only wants a relative path, so lets go bback to the system root
      export ZSH_THEME="../../../../../../../../../../../${powerlevel9k}/share/powerlevel9k/powerlevel9k"
      source $ZSH/oh-my-zsh.sh

    '';
  };

  systemd.user.services = {
    dropbox = {
      Unit = {
        Wants = [ "network-online.target" ];
        After = [ "network-online.target" ];
      };

      Service = {
        ExecStart = "${pkgs.dropbox}/bin/dropbox";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
  systemd.user.startServices = true;
}
