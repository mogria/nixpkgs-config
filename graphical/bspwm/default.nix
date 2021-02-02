{ config, pkgs, ... }:

{
  xsession.windowManager.bspwm = {
    enable = true;
    # package = pkgs.bspwm-unstable;

    # monitors = { HDMI-0 = [ "web" "terminal" "III" "IV" ] ; };

    settings = { border_width = 2; gapless_monocle = true; /* split_ratio = ; */ };

    # startupPrograms = [ "numlockx on" ];

    rules = {
      "Gimp" = {
        desktop = "^8";
        state = "floating";
        follow = true;
        # monitor
      };
      "Kupfer.py" = {
        focus = true;
      };
      "Screenkey" = {
        manage = false;
      };
    };
  };
}
