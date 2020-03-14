{ pkgs, ...}:

{
  programs.zsh = {
      sessionVariables = {
        EDITOR = "vim";
        VISUAL = "vim";
      };
  };

  home.packages = with pkgs; [
    shellcheck
    pythonPackages.sqlparse
    phpPackages.psalm
    ripgrep
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [
      python-language-server
      pylint
    ]);
    plugins = with pkgs.vimPlugins; [
      vim-surround
      vim-nix # nix language support

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

      # saving vim sessions
      vim-obsession
    ];
    extraConfig = import ./config.nix {
      inherit pkgs;
    };
  };

}
