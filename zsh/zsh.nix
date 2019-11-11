{ pkgs, ... }:

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
      # for now use xdg-open, maybe use rifle in the future
      # this is also for having similar behaviour for open like on MacOS
      "open" = "xdg-open";
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

      sessionVariables = {
        EDITOR = "vim";
        VISUAL = "vim";
        FZF_TMUX = "1";
        FZF_TMUX_HEIGHT = "30%";
        # for times the escape needed, because \ is not escaped! when pasting
        # into the bash file
        FZF_COMPLETION_TRIGGER = "\\\\";
        XDG_CONFIG_HOME = "$HOME/.config";
      };
      initExtra = ''
        ${builtins.readFile ./zshrc}
      '';
  };
}
