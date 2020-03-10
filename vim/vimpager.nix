{ pkgs, ...}:

{
  home.packages = with pkgs; [
    vimpager-latest
  ];

  home.sessionVariables = {
    "PAGER" = "vimpager";
  };

  home.file.".vimpagerrc".text = ''
    syntax on

    " easier quitting
    noremap q <Esc>ZQ
    noremap Q <Esc>:q!<CR>

    map Y "+y
    noremap YY ggvG$"+y<C-O><C-O>
  '';
}
