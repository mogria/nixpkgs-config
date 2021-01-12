{ pkgs, config, ... }:

{
  programs.ssh = {
    enable = true;
    controlMaster  = "no";
    forwardAgent = false;
    hashKnownHosts = true;

    matchBlocks = {
      "github.com-guezzldynamic"= { # this domain is translated to github.com
        identityFile = "~/.ssh/guezzldynamic_id_rsa"; # & this identityFile (private key is used);
        hostname = "github.com";
      };
      "github.com" = {
        identityFile = "~/.ssh/id_ecdsa";
        hostname = "github.com";
      };
    };
  };

  home.packages = with pkgs; [
    openssh
  ];
}
