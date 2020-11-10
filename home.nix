{ pkgs, ... }:

let
  config = import ./user-config.nix;
in {
  imports = [
    ./lang.nix
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

  home.stateVersion = "19.09";

  # on 20.03 the manual-combined package does not build
  # https://github.com/nix-community/home-manager/issues/254
  manual.manpages.enable = false;
}
