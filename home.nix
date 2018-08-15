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
  faience-ng-icon-theme = stdenv.mkDerivation rec {
    name = "${pname}-${version}";
    pname = "faience-ng-icon-theme";
    version = "v${releasedate}";
    releasedate = "20180126";
    src =  pkgs.fetchurl {
      url = "https://github.com/faience/${pname}/releases/download/${version}/${pname}-${releasedate}.tar.gz";
      sha256 = "0szpzclsanfjqqaza45am4qfykfprxz4fs5q8hw159xflk91fqv4";
    };
    sourceRoot = ".";
    postUnpack = ''
      mkdir theme
      mv Faience* theme/
    '';
    installPhase = ''
      mkdir -p $out/share/icons
      find theme -mindepth 1 -maxdepth 1 -type d -iname 'Faience-ng*' | while IFS= read dir
      do
        cp -R "$dir" $out/share/icons
        # ${pkgs.gtk2}/bin/gtk-update-icon-cache "$out/share/icons/$dir" 
      done
    '';
  };

  griffin-ghost-icon-theme= stdenv.mkDerivation rec {
    name = "${pname}-${version}";
    pname = "griffin-ghost-icon-theme";
    version = "v${releasedate}";
    releasedate = "20180126";
    src =  pkgs.fetchFromGitHub {
      owner = "Shenron007";
      repo = "Griffin-Icons";
      rev = "5cc20750a79dc9897e67f08ae5d1b6a26ac6e322";
      sha256 = "0ayg1vzlad6zjvaizkanc6vjyznv4af0yd0lpyi7h1zzw17alsbx";
    };
    installPhase = ''
      mkdir -p $out/share/icons/Griffin-Ghost
      cp -R ./* $out/share/icons/Griffin-Ghost
      # ${pkgs.gtk2}/bin/gtk-update-icon-cache "$out/share/icons/$dir"
    '';
  };

  gnome-standard-themes-red = pkgs.gnome3.gnome_themes_standard.overrideDerivation (attrs: {
    install = ''
    echo "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    ls -al
    echo "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
    '';
  });
in {
  programs.home-manager.enable = true;
  programs.home-manager.path = "\$HOME/Code/home-manager";

  home.packages = [
    pkgs.gnome3.gnome_terminal

    /* basic graphical programs */
    pkgs.feh
    pkgs.keepassx
    pkgs.meld

    /* heavier graphical programs */
    pkgs.dropbox
    pkgs.clementine
    pkgs.firefox

    /* theming stuff */
    faience-ng-icon-theme
    gnome-standard-themes-red
    griffin-ghost-icon-theme

    /* shell environment programs */
    pkgs.tmux
    /* zsh, direnv is already included */
    /* vim is still in the nixos configuration :/ share it with root??? */

    /* shell utilities */
    pkgs.jq
    pkgs.ripgrep
    pkgs.tree
    pkgs.binutils
    pkgs.moreutils
    pkgs.coreutils
    pkgs.utillinux
    pkgs.fd
    pkgs.exa
    pkgs.netcat

    /* system management utilities */
    pkgs.iotop
    pkgs.htop
    pkgs.lsof
    pkgs.ltrace

    /* programming utilities */
    pkgs.gdb
    pkgs.gcc
  ];

  programs.rofi = {
    enable = true;
    borderWidth = 2;
    lines = 20;
    width = 60;
    padding = 6;
    rowHeight = 1;
    separator = "solid";
    scrollbar = false;
    location = "bottom";
    xoffset = 0;
    yoffset = 0;
    colors = let
      red = "argb:90e01010";
      white = "#a0a0a0";
    in {
      window = {
        background = "argb:e0101010";
        border = red;
        separator = red;
      };

      rows = {
        normal = {
          foreground = white;
          background = "argb:00000000";
          backgroundAlt = "argb:90101010";
          highlight = {
            background = red;
            foreground = white;
          };
        };
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Mogria";
    userEmail = "m0gr14@gmail.com";
    aliases = {
      "s" = "status";
      "a" = "add";
      "c" = "commit";
      "b" = "branch";
      "d" = "difftool";
      "co" = "checkout";
      "gd" = "diff";
      "gp" = "push";
      "gl" = "pull";
    };
    ignores = [ "*~"  ".*.sw?" ".env" ];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
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
      "gb" = "git branch";
      "gco" = "git checkout";
      "gd" = "git diff";
      "gp" = "git push";
      "gl" = "git pull";
      # make alias expansion work with the following commands as prefix
      "xargs" = "xargs ";
      "sudo" = "sudo ";
      "home-config" = "vim ~/.config/nixpkgs/home.nix";
      "system-config" = "sudo vim /etc/nixos/configuration.nix";
    };
    history = {
      ignoreDups = true;
      share = true;
    };
    profileExtra = ''
      export EDITOR=vim
      export VISUAL=vim
    '';
    initExtra = ''

      if [ -e "$HOME/.zinputrc" ]; then
          source "$HOME/.zinputrc"
      fi

      if [ -e "$HOME/.zprofile" ]; then
          source "$HOME/.zprofile"
      fi

      export TERM="xterm-256color"
      export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
      plugins=(git dircycle composer)

      # case sensitive completion, etc.
      CASE_SENSITIVE=true

      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(command_execution_time status root_indicator)
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(dir vcs)
      POWERLEVEL9K_STATUS_VERBOSE=true
      # ugly hack: oh my zsh only wants a relative path, so lets go bback to the system root
      export ZSH_THEME="../../../../../../../../../../../${powerlevel9k}/share/powerlevel9k/powerlevel9k"
      source $ZSH/oh-my-zsh.sh

      # make sure prompt gets printed on a new line
      setopt PROMPT_SP
      setopt PROMPT_CR
      export PROMPT_EOL_MARK=%B%S%#%s%b
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
