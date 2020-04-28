{ pkgs, ...}:

let
  phpPackages = pkgs.php74Packages; # I can use at least php 7.4 everywhere now I think
in {
  programs.zsh = {
      sessionVariables = {
        EDITOR = "vim";
        VISUAL = "vim";
      };
  };

  home.packages = with pkgs; [
    shellcheck
    pythonPackages.sqlparse
    ripgrep # Used in vim-ripgrep plugin to provide :Rg command
    racket # scheme dialect in use
  ] ++ (with phpPackages; [
    php # ALE linter for php files
    phpcs # ALE fixer for php files
    composer # PHP-Package manager (essential for development and for ale to have vendor/bin/<executable>)
  ]);

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    withPython3 = true;
    withPython = false;
    withNodeJs = false;
    withRuby = false;
    extraPython3Packages = (ps: with ps; [
      python-language-server
      pylint
    ]);
    plugins = with pkgs.vimPlugins; [
      # the best of the junegunn plugins
      vim-easy-align
      fzfWrapper
      fzf-vim

      # tome good tpope plugins
      vim-vinegar # browse directory where file resides by pressing "-"
      vim-surround # add surround keybindings
      vim-eunuch # unix file management
      vim-markdown

      vim-nix # nix language support

      indentLine # show indentlines

      # Tmux Integration
      vim-tmux-focus-events

      # Git Integration
      vim-fugitive
      vim-rhubarb # Github Integration, e.g. :Gbrowse

      # Status bar
      vim-airline
      vim-airline-themes

      LanguageClient-neovim

      # install plugin to be able to install any base16 theme
      # but we just just horizon-dark
      base16-vim

      syntastic

      # language specific stuff
      plantuml-syntax
      vimtex # LaTeX
      bats # tests for bash

      # Snippets
      UltiSnips
      vim-snippets
      neosnippet-snippets

      # Autocompletion
      # neocomplete  # currently doesn't work because this neovim apparently has no lua? Even though it seems to use luajit..

      # easier commenting blocks (CTRL-/ CTRL-/ toggles line or selectino)
      tcomment_vim

      # saving vim sessions
      vim-obsession
    ];
    extraConfig = import ./config.nix {
      inherit pkgs;
    };
  };

  /** install the few vim-plug plugins in a non-reproducable way
   automatically upon 'home-manager switch' by running neovim
   in headless mode to run :PlugInstall
  */
  home.activation = {
    neovimPlugInstall = lib.hm.dag.entryAfter ["installPackages"] ''
      # plugin update rev 1
      # update the number above to force plugin updates, and if it works do it on all
      # machines to have a chance at getting the same setup. Or better yet create a nix derivation for them :)
      $DRY_RUN_CMD nvim -c ':PlugInstall' -c ':PlugDiff' -c ':PlugClean' -c ':q!' -c 'q!' --headless
    '';
  };

}
