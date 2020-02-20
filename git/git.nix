{ pkgs, ... }:

let
  config = import ../user-config.nix;
in {
  programs.git = {
    enable = true;
    userName = config.name;
    userEmail = config.git.email;
    aliases = {
      "s" = "status";
      "a" = "add";
      "ap" = "add --patch";
      "u" = "restore --staged";
      "unstage" = "restore --staged";
      "c" = "commit";
      "b" = "branch";
      "d" = "diff";
      "dc" = "diff --cached";
      "dt" = "difftool";
      "l" = "log";
      "co" = "checkout";
      "k" = "checkout";
      "kp" = "checkout --patch";
      "p" = "push";
      "pl" = "pull --autostash";
      "f" = "fetch --prune --all";
      "undo" = "reset --soft HEAD^";
      "fwd" = "forward";
      "forward" = "merge --ff-only";
      "m" = "merge";
    };
    ignores = [
      "*~" "*.bak*" # backup files
      ".*.sw?" "tags" # vim swap and tag files
      ".env"  ".direnv/" # directory environment configuration files
      "vendor/" "node_modules/" # package manager directories
      ".DS_Store" # get rid of the mac shit
      "*.log" # you probably never want to commit a log file
    ];
    extraConfig = {
      merge = {
        conflictStyle = "diff3";
      };

      push = {
        default = "simple";
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
      };

      mergetool = {
        promt = false;
        nvimdiff = {
          cmd = "nvim -d \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\" -c 'wincmd w' -c 'wincmd J'";
        };
      };
    };
  };
}
