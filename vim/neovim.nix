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
