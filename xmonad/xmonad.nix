{ config, pkgs, ... }:

let
   xmonad = pkgs.xmonad-with-packages.override {
     packages = self: [ self.xmonad-contrib self.taffybar ];
   };
in {
  home.packages = [
    xmonad
  ];

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: [
       haskellPackages.xmonad-contrib
       haskellPackages.monad-logger
    ];

    config = ./xmonad.hs;
  };
}
