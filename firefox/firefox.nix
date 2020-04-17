{ pkgs, ...}:

{
  programs.firefox = {
    /* package = pkgs.firefoxPackages.icecat; */
    # these extensions seem to be from the NUR
    # https://github.com/nix-community/NUR
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      https-everywhere
      ublock-origin
      user-agent-switcher
      cookie-editor
      dark-mode
    ];

    profiles = {
      "hm-default" = {
        id = 0;
        isDefault = true;
        # path = ...;
        settings = {
          "layout.css.devPixelsPerPx" = "1.5"; # when hi-dpi workstation
          "browser.ctrlTab.recentlyUsedOrder" = "false";
          # "browser.download.lastDir" = "/home/.../Downloads"

          # disable useless extensions from firefox itself
          "extensions.pocket.enabled" = "false"; # disable pocket, save links, send tabs
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = "false";
          "identity.fxaccounts.enabled" = "false"; # disable firefox login
          "identity.fxaccounts.toolbar.enabled" = "false";
          "identity.fxaccounts.pairing.enabled" = "false";
          "identity.fxaccounts.commands.enabled" = "false";
          "extensions.abuseReport.enabled" = "false"; # don't show 'report abuse' in extensions
          "browser.contentblocking.report.lockwise.enabled" = "false"; # don't use firefox password manger
          "extensions.fxmonitor.firstAlertShown" = "false"; # don't show advertisement for breach detection
          "browser.uitour.enabled" = "false"; # no tutorial please

          # Auto fill configuration
          "extensions.formautofill.creditCards.enabled" = "false"; # don't auto-fill credit card information

          # disable EME encrypted media extension (Providers can get DRM
          # through this if they include a decryption black-box program)
          "browser.eme.ui.enabled" = "false";
          "media.eme.enabled" = "false";

          # this allows firefox devs changing options for a small amount of users to test out stuff
          # not with me please ... 
          "app.normandy.enabled" = "false";
          "app.shield.optoutstudies.enabled" = "true";

          # no bluetooth location BS in my webbrowser please
          "beacon.enabled" = "false";

          # maybe only makes sense on a phone where we have orientation and motion
          "device.sensors.enabled" = "false";

          # i don't need geolocation in my browser...
          "geo.enabled" = "false";

          # encrypted SNI (domain nanme) when using SSL 
          "network.security.esni.enabled" = "true";

          # don't predict network requests
          "network.predictor.enabled" = "false";
          "browser.urlbar.speculativeConnect.enabled" = "false";
          "browser.urlbar.usepreloadedtopurls.enabled" = "false";

          # disable telemetry for privacy reasons
          "toolkit.telemetry.enabled" = "false";
          "extensions.webcompat-reporter.enabled" = "false";
          "datareporting.policy.dataSubmissionEnabled" = "false";
          "datareporting.healthreport.uploadEnabled" = "false";
          "browser.ping-centre.telemetry" = "false";
          "browser.urlbar.eventTelemetry.enabled" = "false";
          "toolkit.telemetry.unified" = "false";
          "extensions.webcompat-reporter.enabled" = "false"; # dont report compability problems to mozilla


          # disable auto update (as updates are done through nixpkgs
          "extensions.update.enabled" = "false";
          "extensions.update.autoUpdateDefault" = "false";
          "app.update.auto" = "false";

          # disable search suggestions
          "browser.search.suggest.enabled" = "false";
          "browser.search.suggest.enabled.private" = "false";


          # enable strict tracking protection
          "privacy.trackingprotection.enabled" = "true";
          "privacy.trackingprotection.socialtracking.enabled" = "true";

          # enable certificate pinning via HPKP
          "security.cert_pinning.hpkp.enabled" = "true";

          # disable for security, I never use ftp on firefox
          "network.ftp.enable" = "false";

          # always allow resizing textareas
          "editor.resizing.enabled_by_default" = "true";

          # disable annoying web features
          "dom.push.enabled" = "false"; # no notifications, really...
          "dom.push.connection.enabled" = "false";
          "dom.battery.enabled" = "false"; # you don't need to see my battery...
          "dom.event.clipboardevents.enabled" = "false"; # the clipboard is mine, no info leak, except when i want to paste
          "dom.event.contextmenu.enabled" = "false"; # no disabling right-clicking..



          # disable browser crash reporting, send mail to me?
          "browser.tabs.crashReporting.email" = "m0gr14@gmail.com";
          "browser.tabs.crashReporting.emailMe" = "true";
          "browser.tabs.crashReporting.sendReport" = "false";

        };

        userChrome = ''
          ''
      };
    };
  };

  home.packages = with pkgs; [
    # kee pass http??
  ];

};
