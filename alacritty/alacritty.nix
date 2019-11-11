{ pkgs, ... }:

{
  home.packages = [
    pkgs.alacritty
  ];
  xdg.configFile."alacritty/alacritty.yml".text = builtins.readFile ./alacritty.yml;
}
