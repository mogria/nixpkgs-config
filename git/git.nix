{ pkgs, ... }:

let
  config = import ../user-config.nix;
in {
  imports = [
    # ../4git/4git.nix
  ];
  programs.git = {
    enable = true;
    userName = config.name;
    userEmail = config.git.email;
    aliases = {
      "s" = "status";
      "a" = "add";
      "ap" = "add --patch";
      "u" = "restore --staged";
      "up" = "restore --staged --patch";
      "unstage" = "restore --staged";
      "c" = "commit";
      "ca" = "commit --amend";
      "cf" = "commit --fixup";
      "cp" = "cherry-pick";
      "b" = "branch";
      "d" = "diff";
      "dc" = "diff --cached";
      "dt" = "difftool";
      "l" = "log";
      "lp" = "log --patch";
      "co" = "checkout";
      "cop" = "checkout --patch";
      "k" = "checkout";
      "kp" = "checkout --patch";
      "p" = "push";
      "pl" = "pull";
      "plr" = "pull --autostash --rebase";
      "f" = "fetch --prune --all";
      "undo" = "reset --soft HEAD^";
      "fwd" = "forward";
      "forward" = "merge --ff-only";
      "m" = "merge";
      "fx" = "git rebase --autostash --autosquash --interactive";
    };
    ignores = [
      "*~" "*.bak*" # backup files
      ".*.sw?" "tags" # vim swap and tag files
      ".env"  ".direnv/" # directory environment configuration files
      "vendor/" "node_modules/" # package manager directories
      ".DS_Store" # get rid of the mac shit
      "*.log" # you probably never want to commit a log file
      "*.md.pdf" # those get built when using :make when ft=markdown
    ];
    extraConfig = {
      merge = {
        conflictStyle = "diff3";
      };

      push = {
        default = "simple";
      };

      pull = {
        ff = "only";
      };

      # see https://stackoverflow.com/questions/41029654/ignore-fsck-zero-padded-file-mode-errors-in-git-clone
      transfer = {
        fsckobjects = true;
      };

      "receive.fsck".zeroPaddedFilemode = "warn";
      "fetch.fsck".zeroPaddedFilemode = "warn";
      "receive.fsck".badTimezone = "warn";
      "fetch.fsck".badTimezone = "warn";

      # use nvim -d as difftool
      diff = {
        tool = "nvimdiff";
        algorithm = "patience";
      };

      difftool = {
        prompt = false;
        nvimdiff = {
          cmd = "nvim -d \"$LOCAL\" \"$REMOTE\"";
        };
      };

      # use nvim -d as mergetool
      merge = {
        tool = "nvimdiff";
        ff = true; # prefer fast forward merges
      };

      mergetool = {
        promt = false;
        nvimdiff = {
          cmd = "nvim -d \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\" -c 'wincmd w' -c 'wincmd J'";
        };
      };

      color = {
        # this makes vimpager just use syntax highlighting instead of the conceal
        # and the AnsiEsc plugin which is slow
        pager = false;
      };
    };
  };

  home.packages = with pkgs; [
    gitAndTools.gh
  ];
}
