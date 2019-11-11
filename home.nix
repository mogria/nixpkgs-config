{ pkgs, ... }:

let
  config = import ./user-config.nix;
in {
  imports = [
    ./packages.nix
    ./services/dropbox.nix
    ./graphical/packages.nix
  ];
  programs.home-manager = {
    enable = true;
  } // (if config.homemanager.development then {
    path = "${config.getDirectory "code"}/home-manager";
  } else {});

  home.file."bin/" = {
    executable = true;
    source = ./bin;
  };
}
