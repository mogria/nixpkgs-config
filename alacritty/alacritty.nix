{ pkgs, ... }:

{
  home.packages = [
    pkgs.alacritty
  ];
  xdg.configFile."alacritty/alacritty.yml".text = ''
    ${builtins.readFile ./alacritty.yml}
    ${builtins.readFile ./base16-horizon-dark-256.yml}
  '';
}
