{ pkgs, ... }:

{
  imports = [
    ../rofi/rofi.nix
    ../alacritty/alacritty.nix
  ];

  home.packages = [
    /* basic graphical programs */
    pkgs.feh
    (pkgs.keepass.override { xdotool = pkgs.xdotool; })
    pkgs.meld
    pkgs.qutebrowser # maybe use this instead of firefox in the furture
    pkgs.pavucontrol
    pkgs.xdg-user-dirs

    /* heavier graphical programs */
    pkgs.clementine
    pkgs.firefox
    pkgs.chromium  # 2nd browser for specific stuff
    pkgs.thunderbird
    pkgs.okular
    pkgs.audacity

    /* icon themes */
    pkgs.gnome-themes-standard
    pkgs.faience-ng-icon-theme
    pkgs.griffin-ghost-icon-theme

    pkgs.evince # used by vim for tex preview as well
  ];
}


