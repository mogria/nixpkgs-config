{ pkgs, ... }:

let
  config = import ./user-config.nix;
  stdenv = pkgs.stdenv;
  fetchgit = pkgs.fetchgit;
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
in {
  programs.home-manager.enable = true;
  programs.home-manager.path = if config.homemanager.development
      then "${config.getDirectory "code"}/home-manager"
      else config.homemanager.repo "http";

  home.extraOutputsToInstall = [ "doc" "info" "devdoc" ];
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
    pkgs.thunderbird

    /* theming stuff */
    faience-ng-icon-theme
    griffin-ghost-icon-theme

    /* shell environment programs */
    # pkgs.tmux /* already installed by the nixos module */
    pkgs.xclip # required by tmux for copy paste into X clipboard

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
    userName = config.name;
    userEmail = config.git.email;
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
      "prune" = "fetch --prune";
      "undo" = "reset --soft HEAD^";
      "forward" = "merge --ff-only";
    };
    ignores = [ "*~"  ".*.sw?" ".env" ];
    extraConfig = {
      merge = {
        conflictStyle = "diff3";
      };

      push = {
        default = "simple";
      };

      transfer = {
        fsckobjects = true;
      };

      diff = {
        tool = "vimdiff";
      };
      difftool = {
        prompt = false;
      };
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = [ "${pkgs.fd}/bin/fd" "--type" "f" ];
    defaultOptions = [ "--height 40%" "--border" ];
    fileWidgetCommand = [ "${pkgs.fd}/bin/fd" "--type" "f" ];
    fileWidgetOptions = [ "--preview 'file {}; head {}'" ];
    changeDirWidgetCommand = [ "${pkgs.fd}/bin/fd" "--type" "d" ];
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    historyWidgetOptions = [ "--sort" "--exact" ];
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
    history = {
      ignoreDups = true;
      share = true;
    };
      "tmux" = "TERM=screen-256color tmux";
      };

    oh-my-zsh= {
      enable = true;
      plugins = [ "git" "sudo" "dircycle" "composer" ];
      /* ugly hack: oh my zsh only wants a relative path, so lets go bback to the system root */
      theme = "../../../../../../../../../../../${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k";
    };

    profileExtra = ''
      export EDITOR=vim
      export VISUAL=vim
      export TERM="xterm-256color"
  };

  home.file.".tmux.conf" = {
  text = let
      loadPlugin = plugin: "run-shell ${plugin}/${plugin.name}\n";
      yankPlugin = pkgs.fetchFromGitHub {
          name = "yank.tmux";
          owner = "tmux-plugins";
          repo = "tmux-yank";
          rev = "c6a73eba6bfcde51edf57e1cc5fa12c4c7bd98d9";
          sha256 = "04cnr9chq6lwg6zlqvp0zrbn7mzn8w862r1g5b3hmp8ammdvp07x";
      };
    in ''
      # TMUX CONFIGURATION FILE

      # Plugins
      ${loadPlugin yankPlugin}

      # remap prefix from 'C-b' to 'C-a'
      unbind C-b
      unbind C-a
      set-option -g prefix C-q
      bind-key C-q send-prefix

      # split panes using | and -
      unbind '%'
      unbind '"'
      bind | split-window -h
      bind - split-window -v

      # reload config file
      bind r source-file ~/.tmux.conf \; \
           display-message "reloaded config"

      # mouse integration (not that we would need it much... but it's nice)
      set -g mouse on
      # set -g mouse-utf8 off

      # have tmux count the windows/panes from 1, not from 0, better keymapping
      set -g base-index 1
      set -g pane-base-index 1


      # vi style pane selection
      bind -r h select-pane -L
      bind -r j select-pane -D
      bind -r k select-pane -U
      bind -r l select-pane -R

      # vi style pane selection
      bind -r C-h resize-pane -L 11
      bind -r C-j resize-pane -D 7
      bind -r C-k resize-pane -U 7
      bind -r C-l resize-pane -R 10


      #### COLOUR THEME (Solarized dark)
      # default statusbar colors
      set-option -g status-bg black #base02
      set-option -g status-fg yellow #yellow
      set-option -g status-attr default

      # default window title colors
      set-window-option -g window-status-fg brightblue #base0
      set-window-option -g window-status-bg default
      #set-window-option -g window-status-attr dim

      # active window title colors
      set-window-option -g window-status-current-fg brightred #orange
      set-window-option -g window-status-current-bg default
      #set-window-option -g window-status-current-attr bright

      # pane border
      set-option -g pane-border-fg black #base02
      set-option -g pane-active-border-fg brightgreen #base01

      # message text
      set-option -g message-bg black #base02
      set-option -g message-fg brightred #orange

      # pane number display
      set-option -g display-panes-active-colour blue #blue
      set-option -g display-panes-colour brightred #orange

      # clock
      set-window-option -g clock-mode-colour green #green

      # bell
      set-window-option -g window-status-bell-style fg=black,bg=red #base02, red
    '';
    initExtra = ''
      # use the vi keymap
      setopt vi

      if [ -e "$HOME/.zprofile" ]; then
          source "$HOME/.zprofile"
      fi

      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(command_execution_time status root_indicator)
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(dir vcs)
      POWERLEVEL9K_STATUS_VERBOSE=true

      # case sensitive completion, etc.
      CASE_SENSITIVE=true

      # make sure prompt gets printed on a new line
      setopt PROMPT_SP
      setopt PROMPT_CR
      export PROMPT_EOL_MARK=%B%S%#%s%b

      # make sure the FZF keybindings work
      bindkey '^I' fzf-completion
      bindkey '^T' fzf-file-widget
      bindkey '\ec' fzf-cd-widget
      bindkey '^R' fzf-history-widget

      # make most keybindings also work in vim normal mode
      bindkey -M vicmd '^I' fzf-completion
      bindkey -M vicmd '^T' fzf-file-widget
      bindkey -M vicmd '\ec' fzf-cd-widget
      bindkey -M vicmd '^R' fzf-history-widget

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
