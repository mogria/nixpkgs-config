{ pkgs, ... }:

{
  home.packages = [
    pkgs.alacritty
  ];

  xdg.configFile."direnv/direnvrc".text = builtins.readFile ./direnv/direnvrc;
}
