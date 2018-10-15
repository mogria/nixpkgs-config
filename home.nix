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
    /* basic graphical programs */
    pkgs.feh
    pkgs.keepassx
    pkgs.meld
    pkgs.qutebrowser

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
    pkgs.xsel # required by tmux for copy paste into X clipboard

    /* zsh, direnv is already included */
    /* there is also still a vim in the nixos configuration :/ share it with root??? */
    (pkgs.vim_configurable.override {
      pythonSupport = true; # needed for YouCompleteMe Plugin
      python = pkgs.python3; # needed for YouCompleteMe Plugin
      cscopeSupport = true; # gutenberg plugin uses cscope
    })
    pkgs.universal-ctags
    pkgs.cscope
    pkgs.global

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
    borderWidth = 1;
    lines = 50;
    width = 30;
    padding = 1;
    rowHeight = 1;
    separator = "solid";
    scrollbar = false;
    location = "top-right";
    xoffset = 0; # 150; # right beside the xfce panel
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
    defaultCommand = "${pkgs.fd}/bin/fd --type f";
    defaultOptions = [ "--height" "40%" "--border" ];
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f";
    fileWidgetOptions = [ "--preview" "'file {}; head {}'" ];
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
    changeDirWidgetOptions = [ "--preview" "'tree -C {} | head -200'" ];
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
      };
      history = {
        ignoreDups = true;
        share = true;
        save = 100000;
      };

      oh-my-zsh= {
        enable = true;
        plugins = [ "git" "sudo" "dircycle" "composer" ];
        /* ugly hack: oh my zsh only wants a relative path, so lets go bback to the system root */
        theme = "../../../../../../../../../../../${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k";
      };

      sessionVariables = {
        EDITOR = "vim";
        VISUAL = "vim";
        FZF_TMUX = "1";
        FZF_TMUX_HEIGHT = "30%";
        # for times the escape needed, because \ is not escaped! when pasting
        # into the bash file
        FZF_COMPLETION_TRIGGER = "\\\\";
      };
      initExtra = ''
        # disable standard terminal function CTRL-Q and CTRL-S
        # to stop output and resume
        stty -ixon

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
        # auto-command correction
        ENABLE_CORRECTION=true
        # don't show if files are dirty in a git repo
        # as it takes a long time
        DISABLE_UNTRACKED_FILES_DIRTY=true

        # make sure prompt gets printed on a new line
        setopt PROMPT_SP
        setopt PROMPT_CR
        export PROMPT_EOL_MARK=%B%S%#%s%b

        f() {
          local searchterm="''${1:-""}"
          shift
          local out="$(rg -n "$searchterm" "$@" | fzf | cut -d: -f1-2)"
          local file="''${out%:*}"
          if [ -n "$file" ]; then
            "$EDITOR" "$file" +"$(printf "%s\n" "$out" | cut -d: -f2)"
          fi
          return $?
        }
        zle -N fzf-search-files
        bindkey '^F' fzf-search-files

        # shift-tab : go backward in menu (invert of tab)
        bindkey '^[[Z' reverse-menu-complete

        # make sure the FZF keybindings work
        bindkey '^N' fzf-completion
        bindkey '^P' fzf-file-widget
        bindkey '\ec' fzf-cd-widget
        bindkey '^R' fzf-history-widget

        # make most keybindings also work in vim normal mode
        bindkey -M vicmd '^N' fzf-completion
        bindkey -M vicmd '^P' fzf-file-widget
        bindkey -M vicmd '\ec' fzf-cd-widget
        bindkey -M vicmd '^R' fzf-history-widget

        # common emacs keybindings for insert mode
        bindkey -M viins '^A' beginning-of-line
        bindkey -M viins '^E' end-of-line
        bindkey -M viins '^F' forward-char
        bindkey -M viins '^B' backward-char
        bindkey -M viins '^W' kill-word
        bindkey -M viins '^K' kill-line
        bindkey -M viins '^T' transpose-chars
        bindkey -M viins '^[f' forward-word
        bindkey -M viins '^[b' backward-word
        bindkey '^[[1;5C' forward-word # arrow-key right
        bindkey '^[[1;5D' backward-word # arrow-key left

        # in some terminals the delete character doesn't
        # work properly, so make sure it's bound
        bindkey    "^[[3~"          delete-char
        bindkey    "^[3;5~"         delete-char

        # start tmux automatically
        if command tmux -V 2>&1 >/dev/null; then
          # This Environment variable is checked in order
          # to avoid nesting. Because when tmux starts a new
          # shell in it, it will try to launch tmux again!
          if [ -z "$TMUX" ]; then
            tmux
          fi
        fi
    '';
  };

  programs.gnome-terminal = {
     enable = false;
     profile."Default" = {
       default = true;
       font = "Source Code Pro For Powerline";
       scrollbackLines = 1000;
       visibleName = "GTerm";
       showScrollbar = false;
     };
     showMenubar = false;
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


      # remap prefix from 'C-b' to 'C-a'
      unbind C-b
      unbind C-a
      set-option -g prefix C-q
      bind-key C-q send-prefix

      # lower the ncurses escape time, for faster mode switch
      # in vim etc.
      set-option -s escape-time 10

      # only set this here, don't set TERM in .profile, for
      # correct termcap in every environment
      set -g default-terminal "screen-256color"

      # split panes using | and -
      unbind '%'
      unbind '"'
      bind | split-window -h
      bind - split-window -v

      # reload config file
      bind r source-file ~/.tmux.conf \; \
           display-message "reloaded config"

      # mouse integration (not that it's needed  much... but it's nice)
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
      bind -r C-l resize-pane -R 11

      ## Yank into system clipboard

      bind-key -r Space copy-mode
      set -g @yank_selection 'clipboard' # use system clipboard 
      ${loadPlugin yankPlugin}
      # use v or space to start selecting
      bind-key -T copy-mode-vi v send-keys -X begin-selection # 
      # use y or enter to copy the selection
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xsel -i --clipboard"
      # use y to yank a line into the clipboard
      bind-key -T copy-mode-vi Y send-keys -X start-of-line \; send-keys -X start-of-line \; send-keys -X end-of-line \; send-keys -X copy-pipe-and-cancel "xsel -i --clipboard"
      # copy selection into clipboard when releasing mouse
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi Escape send-keys -X cancel


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
  };

  home.file.".vimrc" = let
    languages = {
      "nix" = {
        indent = { size = 2; useTabs = false; cIndent = true; };
        makeCommands = [
          { filePattern = "**/.config/nixpkgs,*.nix"; makeprg = "home-manager\\ switch"; }
          { filePattern = "**/nixos,*.nix"; makeprg = "nixos-rebuild\\ switch"; }
          { filePattern = "*"; makeprg = "nix-repl"; }
        ];
        fileSearchPath = [ "/etc/nixos" "~/.config/nixpkgs" ];
      };
      "python" = {
        indent = { useTabs = true; };
      };
    };

    getOrDefault = key: attrset: defaultValue:
      if builtins.hasAttr key attrset
        then builtins.getAttr key attrset
        else defaultValue;

    # general function which can generate
    # vim config for an option for all languages
    generateAllVimConfigLanguageOptions = option: vimConfigFunc:
      let generateLanguageOptions = lang: languageOptions:
        if builtins.hasAttr option languageOptions
          then vimConfigFunc lang (builtins.getAttr option languageOptions)
          else ""; # just generate an empty string if no option is set
      in builtins.concatStringsSep "\n" (stdenv.lib.mapAttrsToList generateLanguageOptions languages);

    indentVimConfig = let
        vimConfigFunc = lang: indentOption: let
          indent = toString (getOrDefault "size" indentOption 4); # default tab size
          tabsOption = getOrDefault "useTabs" indentOption false; # don't use tabs per default
          cIndent = if getOrDefault "cIndent" indentOption false # use smartindent as default
              then "cindent"
              else "smartindent";
        in ''
          " autocmd FileType ${lang} * set expandtab tabstop=${indent} softtabstop=${indent} shiftwidth=${indent} ${cIndent}
          ${if tabsOption then "\"autocmd FileType ${lang} * set noexpandtab" else ""
          }'';
      in generateAllVimConfigLanguageOptions "indent" vimConfigFunc;

    makeCommandsVimConfig = let
        vimConfigFunc = lang: makeCommandsOption: let
          makeCommand = makeCommandOption: let
            pattern = getOrDefault "filePattern" makeCommandOption "*";
          in ''" autocmd FileType ${lang} ${pattern} set makeprg=${makeCommandOption.makeprg}'';
        in builtins.concatStringsSep "\n" (map makeCommand makeCommandsOption);
      in generateAllVimConfigLanguageOptions "makeCommands" vimConfigFunc;

    fileSearchPathVimConfig = let
        vimConfigFunc = lang: fileSearchPathOption:
          let path = builtins.concatStringsSep "," fileSearchPathOption;
          in ''"autocmd FileType ${lang} * set path+=${path}'';
      in generateAllVimConfigLanguageOptions "fileSearchPath" vimConfigFunc;

  in {
    text = ''
      " MOGRIAS VIM CONFIG (generated by Home-Manager)
      " this vim configuration is in utf8
      scriptencoding utf8
      " set encoding to utf8 by default
      set encoding=utf8

      set nocompatible
      syntax enable

      " GENERAL BEHAVIOUR {{{
        set autowrite " save the opened file automatically when navigating, even tags
        " set autowriteall " save the opened file automatically even when quitting
        set autoread " reload file automatically when changed on disk but not in vim
        " pattern completion in ex mode with * of all files in the
        " working directory and in the folder of the current file

        " have Vim jump to the last position when reopening a file
        if has("autocmd")
          au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
        endif

        " open a quickfix window when using :grep or :Ggrep (from vim-fugitive/git)
        autocmd QuickFixCmdPost *grep* cwindow

        " activate mouse integration
        set mouse=a

        " have some minumum space between border
        " and the cursor on the top and bottom
        set scrolloff=5

        " show line & column number
        set ruler

        " always show vim command autocompletion
        set wildmenu
        set wildmode=longest,full

        " use space as the mapleader for easy combos to type
        let mapleader=" "

        " reload .vimrc and install plugins
        noremap <Leader>r :source ~/.vimrc<CR>
        noremap <Leader>R :source ~/.vimrc<CR>:PluginInstall<CR>

        " CTRL-l like in shell for top of the screen
        noremap <C-l> zt<Esc>:redraw!<CR>
        inoremap <C-l> <Esc>zt:redraw!<CR>i

        " type ! in normal mode to run a command with the current
        noremap ! :!

        " SHIFT-! in normal mode, runs current line as bash command
        noremap <C-S-1> "lyy:!<C-R>l

        " SHIFT-ENTER builds
        noremap <S-Enter> :make<CR>
        inoremap <S-Enter> :make<CR>

        " have all files in current directory in file and cd path
        " when using ex commands or gf in normal mode
        set path +=.,,
        set cdpath +=.,,

        " Language specific search paths
        ${fileSearchPathVimConfig}
      " }}}

      " INSERT MODE EMACS/SHELL KEYBINDINGS {{{
          inoremap <C-b> <Left>
          inoremap <C-f> <Right>
          " overrides repeat last insert, to start of the line, use CTRL-Space instead
          inoremap <C-Space> <C-a>
          imap <C-a> <Esc>^i " beginning of indented line"
          inoremap <C-e> <End>
          " overrides digraphs functionality
          imap <C-k> <Esc>d$A
      " }}}

      " CURSOR AND SIDEBARLAYOUT {{{
        set number
        set antialias
        set cursorline
        set cursorcolumn
      " }}}

      " SEARCHING OPTIONS {{{
        " turn off hlsearch in normal mode with CTRL-N
        set hlsearch
        nnoremap <C-N> <ESC>:nohlsearch<CR>?
        set incsearch " move cursor while typing search
        set smartcase " when using capital letters, the search pattern is case sensitive
      " }}}

      " SPELLING OPTINS {{{
        set spell
        set spelllang=en
        set spellsuggest=best
      " }}}

      " MAKE COMMANDS & QUICKFIX {{{
        " Language Specific make commands
        ${makeCommandsVimConfig}
      " }}}

      " VUNDLE SETUP {{{
          set nocompatible              " be iMproved, required
          filetype off                  " required

          set rtp+=~/.vim/plugin/binary.vim
          " set the runtime path to include Vundle and initialize
          set rtp+=~/.vim/bundle/Vundle.vim
          call vundle#begin()
          " alternatively, pass a path where Vundle should install plugins
          "call vundle#begin('~/some/path/here')

          " let Vundle manage Vundle, required
          Plugin 'gmarik/Vundle.vim'
      " }}}

      " SOLARIZED THEME PLUGIN {{{
        Plugin 'altercation/vim-colors-solarized'
        " Plugin 'godlygeek/tabular'
      " }}}

      " NIX LANGUAGE SUPPORT {{{
        Plugin 'LnL7/vim-nix'
      " }}}

      " INDENTING / TABS & SPACING {{{
        set autoindent
        set smartindent " almost like cindent, but works better for most languages

        set expandtab " convert tabs to spaces
        set smarttab " delete whole tab at once on backspace, even when they are spaces
        set listchars+=tab:»· " show tabs
        set listchars+=trail:·, " show trailing spaces

        set tabstop=4  "four is a good default
        set softtabstop=4 " you can use :set sts=2 for temporarily changing tabstop & shiftwidth


        set shiftwidth=4
        " Language specific indents
        ${indentVimConfig}

        Plugin 'junegunn/vim-easy-align'
        xnoremap <Leader>a <Plug>(EasyAlign)
        nnoremap <Leader>a <Plug>(EasyAlign)
        vnoremap <Leader>a <Plug>(EasyAlign)
      " }}}

      " LINE WRAPPING {{{
        " wrap lines and show an arrow
        set wrap
        set linebreak
        set breakindent
        set showbreak=⮕

        " in case nowrap gets set, show arrows
        set listchars+=precedes:⮕,extends:⬅
      " }}}

      " FZF FUZZY SEARCH {{{
        Plugin 'junegunn/fzf'
        Plugin 'junegunn/fzf.vim'
        noremap <Leader>f <ESC>:Files<CR>
        noremap <Leader>m <ESC>:BLines<CR>
        noremap <Leader>t <Esc>:Tags<CR>
        noremap <Leader>T <Esc>:BTags<CR>
        noremap <Leader>f <ESC>:Rg <C-R>/
        noremap <Leader>F <ESC>:Rg <C-R><C-W>
        noremap <Leader>h <ESC>:Helptags<CR>
        noremap <Leader>/  <ESC>:History/<CR>
        noremap <Leader>:  <ESC>:History\:<CR>
        noremap <Leader><Enter> <ESC>:History<CR>
        noremap <Leader><Space> <ESC>:BTags<CR>
      " }}}

      " TAGS GENERAL {{{
          set cpoptions+=d " set tags+=./,, is relative to the current directory, not the current file
          set tags +=./,,vimtags,~/tags
      " }}}

      " TAGS GUTENTAG (VIM 8 only) {{{
        Plugin 'ludovicchabant/vim-gutentags'
        Plugin 'skywind3000/gutentags_plus'
        " enable gtags module
        let g:gutentags_modules = ['ctags', 'gtags_cscope']

        " config project root markers. .envrc is from direnv and "shell" project management
        let g:gutentags_project_root = ['.root', '.envrc']

        " generate datebases in my cache directory, prevent gtags files polluting my project
        let g:gutentags_cache_dir = expand('~/.cache/tags')

        " forbid gutentags adding gtags databases
        let g:gutentags_auto_add_gtags_cscope = 1
      " }}}


      " TAGS EASYTAGS (old){{{
      "   Plugin 'xolox/vim-misc'
      "   Plugin 'xolox/vim-easytags'
      "   let g:easytags_always_enabled = 1
      "   let g:easytags_async=1
      "   let g:easytags_syntax_keyword = 'always'
      "   let g:easytags_include_members = 1
      "   " tags file per working directory
      "   " set tags=./.vimtags
      "   " let g:easytags_dynamic_files = 1 doesnt work?
      "   let g:easytags_auto_highlight = 0 " doesnt work either...
      " }}}

      " POSTGRESQL SUPPORT {{{
        Plugin 'lifepillar/pgsql.vim'
        " treat .sql files as pgsql
        let g:sql_type_default = 'pgsql'
      " }}}


      " GIT INTEGRATION {{{
        Plugin 'tpope/vim-fugitive'
        " GitHub integration for vim-fugitive
        " for example for :Gbrowse to work
        Plugin 'tpope/vim-rhubarb'
        " setup statusline
        set statusline="f %{FugitiveStatusLine()}"


        " use fzf for searching git files
        noremap <Leader>gf <ESC>:GFiles<CR>
        noremap <Leader>gs <ESC>:GFiles?<CR>

        " bind fugitive functions to <Leader>g*
        noremap <Leader>gw <ESC>:Gbrowse<CR>
        noremap <Leader>gb <ESC>:Gblame<CR>
        noremap <Leader>gl <ESC>:Glog<CR>
        noremap <Leader>gL <ESC>:Gllog<CR>
        noremap <Leader>gd <ESC>:Gdiff<CR>
        noremap <Leader>gc <ESC>:Gcommit<CR>
      " }}}

      " VIM SURROUND {{{
        Plugin 'tpope/vim-surround'
      " }}}

      " FOLDING {{{
        set foldmethod=marker
        set foldnestmax=2 " at most 2 folds in each other, or it gets annoying
        set foldopen=all " open folds, as soon as interacting with them
        set foldcolumn=1
        " augroup vimrc
          " au BufReadPre * setlocal foldmethod=syntax
          " au BufWinEnter * if &fdm == 'syntax' | setlocal foldmethod=manual | endif
        " augroup END
      " }}}

      " AUTOCOMPLETION {{{
        " press <TAB>, when
        Plugin 'Valloric/YouCompleteMe'
        let g:ycm_semantic_triggers =  {
          \   'c' : ['->', '.'],
          \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
          \             're!\[.*\]\s'],
          \   'ocaml' : ['.', '#'],
          \   'cpp,cuda,objcpp' : ['->', '.', '::'],
          \   'perl' : ['->'],
          \   'php' : ['->', '::', '$'],
          \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
          \   'ruby' : ['.', '::'],
          \   'lua' : ['.', ':'],
          \   'erlang' : [':'],
          \   'tpl': ['{', '$', '.'],
          \ }
        " complete brackets etc.

        " add the closing bracket when breaking the line
        " inoremap {<CR> {<CR>}<C-O>O
        " inoremap (<CR> (<CR>)<C-O>O
        " inoremap [<CR> [<CR>]<C-O>O

        Plugin 'rstacruz/vim-closer'
        Plugin 'tpope/vim-endwise'
      " }}}

      " PHP SUPPORT (unneeded?){{{
      "  Plugin '2072/PHP-Indenting-for-VIm'
      "  " Plugin 'rayburgemeestre/phpfolding.vim'
      "  Plugin 'vim-vdebug/vdebug'
      "  Plugin 'shawncplus/phpcomplete.vim'
      "  let g:PHP_removeCRwhenUnix=1
      "  autocmd FileType php set omnifunc=phpcomplete#CompletePHP
      " }}}

      " HTML integration {{{
        Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
      "}}}

      " GLSL support {{{
        Plugin 'tikhomirov/vim-glsl'
      " }}}

      Plugin 'tomtom/tcomment_vim'

      " All of your Plugins must be added before the following line
      call vundle#end()            " required
      filetype plugin indent on    " required

      " SOLARIZED THEME {{{
        set t_Co=16
        syntax enable
        set background=dark
        let g:solarized_termcolors=256
        colorscheme solarized
      " }}}

      " NETRW FILE MANAGER {{{
        let g:netrw_banner = 0
        let g:netrw_liststyle = 3
        let g:netrw_fastbrowse = 1
        let g:netrw_list_hide = netrw_gitignore#Hide().'.*\.sw.$'
        let g:netrw_localmkdiropt = '-p'
      " }}}

      " VDEBUG OPTIONS {{{
      " if !exists('g:vdebug_options')
      "   let g:vdebug_options = {}
      " endif
      " let g:path_maps = {
      "           \ "/home/guezzl-deployer/guezzlpage" : "/home/mkuettel/Code/guezzlpage"
      "           \ }
      " let g:vdebug_options.break_on_open = 0
      " }}}

    '';
  };

  programs.command-not-found.enable = true;

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
