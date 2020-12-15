{ pkgs, ... }:

let
  config = import ./user-config.nix;
in {
  imports = [
    ./lang.nix
    ./packages.nix
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

  home.stateVersion = "19.09";

  manual.manpages.enable = true;
}
