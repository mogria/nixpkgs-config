{ config, pkgs, ... }:

{
  home.language.base = "en_US.UTF-8";
  home.language.monetary ="e_CH.UTF-8";
  home.language.paper = "de_CH.UTF-8";
  home.language.time = "de_CH.UTF-8";

  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
  };
}
