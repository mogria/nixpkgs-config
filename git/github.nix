{ pkgs, ... }:

let
  config = import ../user-config.nix;
in {

  # Git Hub Cli utility
  programs.git = {
    aliases = {
      "hub" = "!gh";
    };
  };

  programs.zsh.shellAliases = {
    "github" = "gh";
  };

  home.packages = with pkgs; [
    gitAndTools.gh
  ];
}
