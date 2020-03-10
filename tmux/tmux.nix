{ pkgs, ... }:

{
  home.packages = [
    pkgs.tmux /* already installed by the nixos module */
    pkgs.ncurses /* for terminfo database */
  ];

  home.file.".tmux.conf" = {
    text = let
      loadPlugin = plugin: "run-shell ${plugin.src}/${plugin.name}\n";
      yankPlugin = {
        name = "yank.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "tmux-plugins";
          repo = "tmux-yank";
          rev = "648005db64d9bf3c4650eff694ecb6cf3e42b0c8";
          # latest release 2.3.0 does not include mouse support and does not support tmux 3.0
          sha256 = "1zg9k8yk1iw01vl8m44w4sv20lln4l0lq9dafc09lxmgxm9dllj4";
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
          rev = "aa59077c635ab21b251bd8cb4dc24c415e64a58e";
          sha256 = "06346ih3hzwszhkj25g4xv5av7292s6sdbrdpx39p0n3kgf5mwww";
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
      powerlinePlugin = {
        name = "tmux-powerline";
        src = pkgs.fetchFromGitHub {
          owner = "erikw";
          repo = "tmux-powerline";
          rev = "e214721694661448176580433fd563f82542545a";
          sha256 = "0f9xwlnjwsy7b8w76j5pg9hd0s01vwry574jfg4pi2lc3hbjkab5";
        };
      };
  in ''
      ${builtins.readFile ./tmux.conf}

      ## Yank into system clipboard

      bind-key -r Space copy-mode
      set -g @yank_selection 'clipboard'
      set -g @yank_with_mouse 'on'
      set -g @yank_selection_mouse 'clipboard'
      ${loadPlugin yankPlugin}

      ${loadPlugin copycatPlugin}

      set -g @open-S 'https://www.duckduckgo.com/' # use duckduckgo instead of google
      ${loadPlugin openPlugin}

      set -g @emulate-scroll-for-no-mouse-alternate-buffer 'on'
      ${loadPlugin betterMouseModePlugin}

      # for restoring vim
      set -g @resurrect-strategy-vim 'session'
      # for restoring neovim
      set -g @resurrect-strategy-nvim 'session'
      # restore pane contents
      set -g @resurrect-caoture-pane-contents 'on'
      ${loadPlugin resurrectPlugin}

      set -g @continuum-restore 'on'
      ${loadPlugin continuumPlugin}

      # tmux-powerline statusbar configuration
      set-option -g status on
      set-option -g status-interval 1
      set-option -g status-justify left
      set-option -g status-left-length 40
      set-option -g status-right-length 90
      set-option -g status-left "#(${powerlinePlugin.src}/powerline.sh left)"
      set-option -g status-right "#(${powerlinePlugin.src}/powerline.sh right)"
    '';

  };

  home.file.".tmux-powerlinerc" = {
    source = ./tmux-powerlinerc;
    target = ".tmux-powerlinerc";
  };
}
