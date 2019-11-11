{ pkgs, ...}:

{
  xdg.configFile."direnv/direnvrc".text = builtins.readFile ./direnvrc;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}

