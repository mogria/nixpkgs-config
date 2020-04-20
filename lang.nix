{ config, pkgs, ... }:

{
  home.language.base = "en_US.UTF-8";
  home.language.monetary ="de_CH.UTF-8";
  home.language.paper = "de_CH.UTF-8";
  home.language.time = "de_CH.UTF-8";

  home.sessionVariables = {
    LANGUAGE = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
  };
}
