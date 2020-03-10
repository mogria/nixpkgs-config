{ pkgs, ...}:

{
  home.packages = with pkgs; [
    vimpager
  ];

  home.sessionVariables = {
    "PAGER" = "vimpager";
  };

  home.file.".vimpagerrc".text = ''
    syntax on
  '';
}
