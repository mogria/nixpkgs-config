{ pkgs, lib, ... }:

let
  configFilePath = ".ripgrep-config";
in {
  home.packages = with pkgs; [
    ripgrep
  ];


  xdg.configFile."${configFilePath}".text = ''
    # make rg also understand POSIX regex, for example from vim not only PCRE2
    --auto-hybrid-regex
    # Treat CRLF as a line ending as well, so $ matches
    --crlf
    # smart-case as in vim (case insensitive when pattern only lowercase)
    --smart-case
  '';

}
