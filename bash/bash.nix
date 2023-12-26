{ pkgs, config, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = ["ignoredups"];
    shellAliases = import ./aliases.nix;

    enableVteIntegration = true;

    profileExtra = builtins.readFile ./bash_profile;

    bashrcExtra = builtins.readFile ./bashrc;

    shellOptions = [
      "extglob"
      "globstar"
    ];
  };
}
