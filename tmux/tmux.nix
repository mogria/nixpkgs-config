{ pkgs, ... }:

{
  home.packages = [
    pkgs.tmux /* already installed by the nixos module */
    # pkgs.tmux-256colors-terminfo /* own terminfo for tmux */
  ];

  home.file.".tmux.conf" = {
  text = let
      loadPlugin = plugin: "run-shell ${plugin.src}/${plugin.name}\n";
      yankPlugin = {
        name = "yank.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "tmux-plugins";
          repo = "tmux-yank";
          rev = "v2.3.0";
          sha256 = "0yqar2y58p4h9k8jzkb8i8ph0mdmha0909cpgb0qyfpi26q0410d";
        };
      };
      copycatPlugin = {
        name = "copycat.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "tmux-plugins";
          repo = "tmux-copycat";
          rev = "v3.0.0";
          sha256 = "0f1c6cbi5kr7n9r5ldhiz7mcb910ikp87ikga9yjz211w8g02987";
        };
      };
      openPlugin = {
        name = "open.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "tmux-plugins";
          repo = "tmux-open";
          rev = "v3.0.0";
          sha256 = "13q3zd5jv7akkjjwhgimmfylrvalxdn54fnpfb14g6xam6h8808m";
        };
      };
      betterMouseModePlugin = {
        name = "scroll_copy_mode.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "nhdaly";
          repo = "tmux-better-mouse-mode";
          rev = "c6a73eba6bfcde51edf57e1cc5fa12c4c7bd98d9";
          sha256 = "04cnr9chq6lwg6zlqvp0zrbn7mzn8w862r1g5b3hmp8ammdvp07x";
        };
      };
      resurrectPlugin = {
        name = "resurrect.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "tmux-plugins";
          repo = "tmux-resurrect";
          rev = "v2.4.0";
          sha256 = "08nmf3d8klyysl9d2kjrdmsvkwfp3lxsgc74cn02x2haqidsd4cq";
        };
      };
      continuumPlugin = {
        name = "continuum.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "tmux-plugins";
          repo = "tmux-continuum";
          rev = "v3.1.0";
          sha256 = "1canvdva14sd8czjv6kq2wmd6lzqn23zxm0spazavxfi2ar9qkbv";
        };
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
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"
      # use y to yank a line into the clipboard
      bind-key -T copy-mode-vi Y send-keys -X start-of-line \; send-keys -X start-of-line \; send-keys -X end-of-line \; send-keys -X copy-pipe-and-cancel "pbcopy"
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
