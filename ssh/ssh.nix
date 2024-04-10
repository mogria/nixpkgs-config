{ pkgs, config, ... }:

{
  programs.ssh = {
    enable = true;
    controlMaster  = "no";
    forwardAgent = false;
    hashKnownHosts = true;

    matchBlocks = {
      "github.com-mogria"= { # this domain is translated to github.com
        identityFile = "~/.ssh/id_ed25519_mogria"; # & this identityFile (private key is used);
        hostname = "github.com";
      };
      "github.com" = {
        identityFile = "~/.ssh/id_ed25519";
        hostname = "github.com";
      };
      "gitlab.hostmax.ch" = {
      	identityFile = "~/.ssh/id_ed25519";
      	hostname = "gitlab.hostmax.ch";
      };
    };
  };

  home.packages = with pkgs; [
    openssh
  ];
}
