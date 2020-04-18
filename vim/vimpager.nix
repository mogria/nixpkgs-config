{ pkgs, ...}:

{
  home.packages = with pkgs; [
    vimpager-latest
    # there is also the nixpkgs.page package which uses
    # neovim as a pager...
  ];

  home.sessionVariables = {
    "PAGER" = "vimpager";
  };

  home.file.".vimpagerrc".text = ''
    syntax on

    set incsearch
    set ignorecase
    " searches with only small latters are case-insensitive
    set smartcase
    " start search again
    set wrapscan

    " easier quitting
    noremap q <Esc>ZQ
    noremap Q <Esc>:q!<CR>

    map Y "+y
    noremap YY ggvG$"+y<C-O><C-O>

    nmap <Space> v

    " OLD VIMPAGER CONFIGURATION {{{
    " let g:vimpager = {}
    " let g:vimpager.ansiesc = 0
    " let g:less = {}
    " Plugin 'rkitover/vimpager'
    " }}}

  '';
}
