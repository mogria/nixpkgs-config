{
  # FZF cd widget
  "c" = "fzf-cd-widget";
  "bat" = "bat -pp --theme base16-256 --italic-text always";
  "p" = "bat";
  "pc" = "bat -d --color=always";

  # override some default options on interactive use
  "ls" = "eza --git";
  "la" = "eza --git -a";
  "ll" = "eza -l -g -a --sort=modified --git";
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
  # "gL" = let
  #     # launches vim and closes the opened dummy split
  #     scriptFile = pkgs.writeText "vim-git-log" " gl<C-W><C-W>ZQvis\n";
  # in "vim -s ${scriptFile} .";
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
}
