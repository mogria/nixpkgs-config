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
  ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [
      python-language-server
      pylint
      sqlparse # for sqlformat, used as equalprg in vim
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

      # saving vim sessions
      vim-obsession
    ];
    extraConfig = import ./config.nix {
      inherit pkgs;
    };
  };

}
