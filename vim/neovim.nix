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
    ];
    extraConfig = import ./config.nix {
      inherit pkgs;
    };
  };

}
