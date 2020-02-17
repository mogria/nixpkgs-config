{ pkgs, ... }:

{
  home.packages = [
    pkgs.fd
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
    defaultOptions = [ "--height" "40%" "--border" ];
    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [ "--preview" "'file {}; head {}'" ];
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [ "--preview" "'tree -C {} | head -200'" ];
    historyWidgetOptions = [ "--sort" "--exact" ];
  };

  home.sessionVariables = {
    FZF_TMUX = "1";
    FZF_TMUX_HEIGHT = "30%";
    # for times the escape needed, because \ is not escaped! when pasting
    # into the bash file
    FZF_COMPLETION_TRIGGER = "\\\\";
  };
}
