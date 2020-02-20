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
    ripgrep

    /* used for generating tags in vim */
    universal-ctags
    cscope
    global
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

      # Git Integration
      vim-fugitive
      vim-rhubarb # Github Integration, e.g. :Gbrowse

      LanguageClient-neovim

      base16-vim

      syntastic

      plantuml-syntax

      # Snippets
      UltiSnips
      vim-snippets
      neosnippet-snippets

      # LaTeX
      vimtex

      # saving vim sessions
      vim-obsession
    ];
    extraConfig = import ./config.nix {
      inherit pkgs;
    };
  };

}
