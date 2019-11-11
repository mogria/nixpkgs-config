{ pkgs, ... }:

{
  home.packages = [
    pkgs.tmux /* already installed by the nixos module */
    # pkgs.tmux-256colors-terminfo /* own terminfo for tmux */
    pkgs.xsel # required by tmux for copy paste into X clipboard
  ];

  home.file.".tmux.conf" = {
  text = let
      loadPlugin = plugin: "run-shell ${plugin}/${plugin.name}\n";
      yankPlugin = pkgs.fetchFromGitHub {
          name = "yank.tmux";
          owner = "tmux-plugins";
          repo = "tmux-yank";
          rev = "c6a73eba6bfcde51edf57e1cc5fa12c4c7bd98d9";
          sha256 = "04cnr9chq6lwg6zlqvp0zrbn7mzn8w862r1g5b3hmp8ammdvp07x";
      };
      copycatPlugin = pkgs.fetchFromGitHub {
          name = "copycat.tmux";
          owner = "tmux-plugins";
          repo = "tmux-copycat";
          rev = "c6a73eba6bfcde51edf57e1cc5fa12c4c7bd98d9";
          sha256 = "04cnr9chq6lwg6zlqvp0zrbn7mzn8w862r1g5b3hmp8ammdvp07x";
      };
      openPlugin = pkgs.fetchFromGitHub {
          name = "open.tmux";
          owner = "tmux-plugins";
          repo = "tmux-open";
          rev = "c6a73eba6bfcde51edf57e1cc5fa12c4c7bd98d9";
          sha256 = "04cnr9chq6lwg6zlqvp0zrbn7mzn8w862r1g5b3hmp8ammdvp07x";
      };
      betterMouseModePlugin = pkgs.fetchFromGitHub {
          name = "scroll_copy_mode.tmux";
          owner = "nhdaly";
          repo = "tmux-better-mouse-mode";
          rev = "c6a73eba6bfcde51edf57e1cc5fa12c4c7bd98d9";
          sha256 = "04cnr9chq6lwg6zlqvp0zrbn7mzn8w862r1g5b3hmp8ammdvp07x";
      };
      resurrectPlugin = pkgs.fetchFromGitHub {
          name = "resurrect.tmux";
          owner = "tmux-plugins";
          repo = "tmux-resurrect";
          rev = "c6a73eba6bfcde51edf57e1cc5fa12c4c7bd98d9";
          sha256 = "04cnr9chq6lwg6zlqvp0zrbn7mzn8w862r1g5b3hmp8ammdvp07x";
      };
      continuumPlugin = pkgs.fetchFromGitHub {
          name = "continuum.tmux";
          owner = "tmux-plugins";
          repo = "tmux-continuum";
          rev = "c6a73eba6bfcde51edf57e1cc5fa12c4c7bd98d9";
          sha256 = "04cnr9chq6lwg6zlqvp0zrbn7mzn8w862r1g5b3hmp8ammdvp07x";
      };
  in ''
      ${builtins.readFile ./tmux.conf}

      ## Yank into system clipboard

      bind-key -r Space copy-mode
      set -g @yank_selection 'clipboard' # use system clipboard 
      ${loadPlugin yankPlugin}

      # use v or space to start selecting
      bind-key -T copy-mode-vi v send-keys -X begin-selection # 
      # use y or enter to copy the selection
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xsel -i --clipboard"
      # use y to yank a line into the clipboard
      bind-key -T copy-mode-vi Y send-keys -X start-of-line \; send-keys -X start-of-line \; send-keys -X end-of-line \; send-keys -X copy-pipe-and-cancel "xsel -i --clipboard"
      # copy selection into clipboard when releasing mouse
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi Escape send-keys -X cancel

      ${loadPlugin copycatPlugin}

      set -g @open-S 'https://www.duckduckgo.com/' # use duckduckgo instead of google
      ${loadPlugin openPlugin}

      set -g @emulate-scroll-for-no-mouse-alternate-buffer 'on'
      ${loadPlugin betterMouseModePlugin}

      set -g @continuum-restore 'on'
      ${loadPlugin resurrectPlugin}
      ${loadPlugin continuumPlugin}
    '';
  };
}
