{ pkgs, ... }:

{
  home.packages = [
    pkgs.jq
    pkgs.tree
  ];

  programs.home-manager.enable = true;
  programs.home-manager.path = "https://github.com/rycee/home-manager/archive/master.tar.gz";

  programs.git = {
    enable = true;
    userName = "Mogria";
    userEmail = "m0gr14@gmail.com";
  };
}
