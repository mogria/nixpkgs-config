{ pkgs, config, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    shellAliases = {
      # FZF cd widget
      "c" = "fzf-cd-widget";
      "bat" = "bat -pp --theme base16-256 --italic-text always";
      "p" = "bat";
      "pc" = "bat -d --color=always";

      # override some default options on interactive use
      "ls" = "exa --git";
      "la" = "exa --git -a";
      "ll" = "exa -l -g -a --sort=modified --git";
      "cp" = "cp -iv";
      "mv" = "mv -iv";
      "rm" = "rm -iv";
      "mkdir" = "mkdir -pv";
      "du" = "du -h";
      "df" = "df -h";
      "grep" = "grep --color=auto";
      "curl" = "curl -v";

      # git aliases, they should be mostly consistent with
      # git configured git aliases, and a lot of times even
      # uses the aliases to provide the correct default options.
      "gs" = "git status";
      "gS" = "vim -c ':Gstatus' -c 'wincmd w' -c 'close' +/Unstaged";
      "ga" = "git a";
      "gap" = "git ap";
      "gu" = "git unstage";
      "gup" = "git up";
      "gc" = "git commit";
      "gca" = "git commit --amend";
      "gcf" = "git commit --fixup=`fzf-commit`";
      "gcp" = "git cp"; #cherry-pick
      "gb" = "git branch";
      "gd" = "git diff";
      "gD" = "nvim -c :Gdiff";
      "gdc" = "git diff --cached";
      "gdt" = "git difftool";
      "gl" = "git log";
      "glp" = "git log --patch";
      "gL" = let
          # launches vim and closes the opened dummy split
          scriptFile = pkgs.writeText "vim-git-log" " gl<C-W><C-W>ZQvis\n";
        in "vim -s ${scriptFile} .";
      # checkout / checkout patched
      "gco" = "git co";
      "gcop" = "git cop";
      "gk" = "git k";
      "gkp" = "git kp";
      "gp" = "git p"; #push
      "gpl" = "git pl"; #pull
      "gplr" = "git plr"; #pull --rebase --autostash
      "gf" = "git f"; # fetch
      "gfwd" = "git forward"; # --ff-only merge
      "gfx" = "git rebase --autostash --autosquash --interactive";
      "gundo" = "git undo"; #undo last commit
      "gx" = "git undo";
      "gm" = "git m"; # merge
      "gmt" = "git mergetool"; # mergetool
      # make alias expansion work with the following commands as prefix
      "xargs" = "xargs ";
      "sudo" = "sudo ";
      "home-config" = "vim ~/.config/nixpkgs/home.nix";
      "system-config" = "sudo vim /etc/nixos/configuration.nix";
      # make sure I don't use the old broken nix-repl (needs NIX_REMOTE=daemon set on NixOS)
      "nix-repl" = "nix repl";

      # Often used commands
      "hs" = "home-manager switch";
      "hsu" = "nix-channel --update && home-manager switch";
      };
      history = {
        ignoreDups = true;
        share = true;
        save = 100000;
      };

      oh-my-zsh= {
        enable = true;
        plugins = [ "dircycle" "zsh-navigation-tools" "ssh-agent" ];
        /* ugly hack: oh my zsh only wants a relative path, so lets go back to the system root */
        theme = "../../../../../../../../../../../${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k";
        extraConfig = ''
          zstyle :omz:plugins:ssh-agent identities id_ecdsa
        '';
      };

      sessionVariables = config.home.sessionVariables;

      initExtra = ''
        ## END NIX
        ## The previous part of this ZSHRC is generated by nix and configured in ~/.config/nixpkgs/zsh/zsh.nix
        ## The following part of this  ZSHRC is read from ~/.config/nixpkgs/zsh/zshrc

        ${builtins.readFile ./zshrc}
      '';

      profileExtra = ''
        export PATH=$HOME/scripts:$HOME/bin:/opt/local/bin:/usr/local/bin:$PATH

        # set TERMINFO to the terminfos delivered by the ncurses nix package
        if [ ! -f /etc/NIXOS ]; then
          export TERMINFO=$HOME/.nix-profile/share/terminfo
          # source system wide zshrc, for nix configuration if it exists
          # so that the nix profile variables get set (e.g. NIX_REMOTE)
          # (this might be MacOS/"Darwin" specific, or also work the same way other linux distributions)
          [ -f /etc/zshrc ] && source /etc/zshrc
        fi
      '';
  };


  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    XDG_CONFIG_HOME = "$HOME/.config";
  };
}
