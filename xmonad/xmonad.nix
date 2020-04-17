{ config, pkgs, ... }:

let
   # xmonad = pkgs.xmonad-with-packages.override {
   #   packages = self: [ self.xmonad-contrib self.taffybar ];
   # };
   haskellPackages = pkgs.haskellPackages;
in {
  # home.packages = [
  #   xmonad
  # ];

  # home.files.".xinitrc".text = ''
      # the xrdb package includes this
  #   # xrdb -merge .Xresources
  #   # the fvwm package includes this
  #   # xpmroot ~/background.xpm &
  #   xmonad
  # '';

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    inherit haskellPackages;
    extraPackages = haskellPackages: [
       haskellPackages.xmonad-contrib
       haskellPackages.monad-logger
    ];

    config = ./xmonad.hs;
  };
}
