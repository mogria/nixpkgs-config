{ pkgs, config, ... }:

{
  programs.ssh = {
    enable = true;
    controlMaster  = "no";
    forwardAgent = false;
    # hashKnownHosts = true;
  };

  home.packages = with pkgs; [
    openssh
  ];
}
