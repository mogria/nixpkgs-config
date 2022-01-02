{ config, pkgs, ... }:

{
  home.language.base = "en_US.UTF-8";
  home.language.address = "de_CH.UTF-8";
  home.language.collate = "de_CH.UTF-8";
  home.language.ctype = "de_CH.UTF-8";
  home.language.measurement ="de_CH.UTF-8";
  home.language.messages ="en_US.UTF-8";
  home.language.monetary ="de_CH.UTF-8";
  home.language.name ="de_CH.UTF-8";
  home.language.numeric ="de_CH.UTF-8";
  home.language.paper = "de_CH.UTF-8";
  home.language.time = "de_CH.UTF-8";

  home.sessionVariables = {
    LANGUAGE = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
}
