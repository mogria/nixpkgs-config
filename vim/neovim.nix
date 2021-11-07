{ pkgs, lib, ... }:

let
  # I can use at least php 7.4 everywhere now I think
  phpPackages = pkgs.php74Packages;
in {

  imports = [
    ./coc-vim.nix
  ];

  programs.zsh = {
      sessionVariables = {
        EDITOR = "vim";
        VISUAL = "vim";
        # NVIM_RPLUGIN_MANIFEST = "~/.local/share/nvim/rplugin.vim";
      };
  };

  home.packages = with pkgs; [
    neovim-remote # control nvim processes from terminal
    proselint # lint text data

    # clang # ALE linter for C/C++ 
    ripgrep # Used in vim-ripgrep plugin to provide :Rg command
    plantuml # for building plantuml files
    vim-vint # Ale Linter lint vimscript/vimrc
    racket # scheme dialect in use
  ];


  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withNodeJs = true;
    withRuby = false;
    extraPython3Packages = (ps: with ps; [
      pynvim
    ]);
    plugins = with pkgs.vimPlugins; [
      ## also configurable like this:
      ## { plugin = vim-startify; config = "let g:startify_change_to_vcs_root = 0"; }

      vim-plug # some plugins are not nixexpressions, use vim-plug as plugin manager

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

      bats-vim # bash automated scripting system

      indentLine # show indentlines

      # Tmux Integration
      vim-tmux-focus-events

      # Git Integration
      vim-fugitive
      vim-rhubarb # Github Integration, e.g. :Gbrowse

      # Status bar
      vim-airline
      vim-airline-themes


      # install plugin to be able to install any base16 theme
      # but we just just horizon-dark
      base16-vim

      # asynchronous syntax checker and fixer
      ale

      # language specific stuff
      plantuml-syntax
      sved

      vimtex # LaTeX
      vim-latex-live-preview

      # Snippets
      UltiSnips
      vim-snippets
      neosnippet-snippets

      # Autocompletion
      # neocomplete  # currently doesn't work because this neovim apparently has no lua? Even though it seems to use luajit..
      deoplete-nvim
      neco-vim
      deoplete-dictionary
      # deoplete-zsh
      # deoplete-clang
      cpsm # fast fuzzy matching for completion
      tmux-complete-vim # complete in vim from tmux panes
      context_filetype-vim
      # nvim-lsp isused as the language server Language Server
      # deoplete-lsp # nvim-lsp integration

      # (pkgs.fetchUrl {
      #   url = "https://github.com/thomasfaingnaert/vim-lsp-ultisnips/archive/494cd3c16b1d590e10c66d6cc10ace4dfe094085.zip";
      #   sha256 = "1pl3gwzr5691jbm5f2fmicgqjzr4pvq7bl1fry7jbldr6ab74san";
      # })

      # display documentation
      echodoc

      # easier commenting blocks (CTRL-/ CTRL-/ toggles line or selectino)
      tcomment_vim

      # saving vim sessions
      vim-obsession

      # close XML/HTML tags
      vim-closetag 
    ];
    extraConfig = (import ./config.nix {
      inherit pkgs;
    });
    package = pkgs.neovim-unwrapped;
  };

  # vim-plug needs to be autoloaded for the :Plug command to be available in the vimrc
  xdg.configFile."nvim/autoload/plug.vim".source = "${pkgs.vimPlugins.vim-plug}/share/vim-plugins/vim-plug/plug.vim";

  /** install the few vim-plug plugins in a non-reproducable way
   automatically upon 'home-manager switch' by running neovim
   in headless mode to run :PlugInstall
  */
  home.activation = {
    neovimPlugInstall = lib.hm.dag.entryAfter ["installPackages"] ''
      # plugin update rev 1
      # update the number above to force plugin updates, and if it works do it on all
      # machines to have a chance at getting the same setup. Or better yet create a nix derivation for them :)
      $DRY_RUN_CMD nvim -c ':PlugInstall!' -c ':PlugDiff' -c ':PlugClean!' -c ':q!' -c 'q!' --headless
    '';
  };

}
