{ pkgs, config, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    shellAliases = {
      "c" = "fzf-cd-widget";
      "ls" = "exa --git";
      "ll" = "exa -l -a --sort=modified --git";
      "gs" = "git status";
      # git aliases, they should be mostly consitent with
      # git configured git aliases
      "ga" = "git add";
      "gu" = "git unstage";
      "gc" = "git commit";
      "gx" = "git undo-commit";
      "gb" = "git branch";
      "gd" = "git diff";
      "gdc" = "git diff --cached";
      "gdt" = "git difftool";
      "gl" = "git log";
      "gco" = "git checkout";
      "gk" = "git checkout";
      "gp" = "git push";
      "gpl" = "git pull";
      "gf" = "git fetch";
      "gfwd" = "git forward";
      # make alias expansion work with the following commands as prefix
      "xargs" = "xargs ";
      "sudo" = "sudo ";
      "home-config" = "vim ~/.config/nixpkgs/home.nix";
      "system-config" = "sudo vim /etc/nixos/configuration.nix";
      };
      history = {
        ignoreDups = true;
        share = true;
        save = 100000;
      };

      oh-my-zsh= {
        enable = true;
        plugins = [ "gitfast" "sudo" "dircycle" "zsh-navigation-tools" ];
        /* ugly hack: oh my zsh only wants a relative path, so lets go back to the system root */
        theme = "../../../../../../../../../../../${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k";
      };

      sessionVariables = config.home.sessionVariables;

      initExtra = ''
        ${builtins.readFile ./zshrc}
      '';

      profileExtra = ''
        export PATH=$HOME/scripts:$HOME/bin:/opt/local/bin:/usr/local/bin:$PATH

        # set TERMINFO to the terminfos delivered by the ncurses nix package
        if [ ! -f /etc/NIXOS ]; then
          export TERMINFO=$HOME/.nix-profile/share/terminfo
        fi
      '';
  };


  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    XDG_CONFIG_HOME = "$HOME/.config";
    LANG  = "en_US.UTF-8";
    LC_TYPE = "en_US.UTF-8";
  };
}
