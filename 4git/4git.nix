{ pkgs, ... }:

let
  fourgit = pkgs.callPackage ./default.nix { };
in {
  home.packages = [
    fourgit
  ];
}
