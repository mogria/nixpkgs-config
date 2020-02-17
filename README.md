# Mogria's .dotfiles

These are [Home-Manager](https://github.com/rycee/home-manager/) based
configuration for my home directory files.

Home-Manager allows one to configure his own `$HOME` directory using the
[nix](https://nixos.org/nix/) language and the
[nixpkgs](https://nixos.org/nix/) package collection.

These configuration files are in use on multiple 64-Linux Linux NixOS machine's
and on a recent MacBook.  Some minor modifications might be needed to make them
runnable on other architectures or with other distributions than NixOS
just using the Nix package manager.

# Environment and Tools Included

This collection of configuration files and script almost gives you a complete
"IDE"-like environment. At least, I use it as such. This environment is heavily
tuned toward how my own workflow works (keybindings and programs used and
such). So feel free to adjust these files to your wishes or take out little
bits and pieces here and there.

## Programming: NeoVim

These configuration files contain a heavily customized neovim with a lot of
plugins for supporting programming. I usually start multiple instances of
neovim inside `tmux`. The `.zshrc` automatically starts a new tmux session.

Some of the plugins include:

* [Syntastic](https://github.com/vim-syntastic/syntastic)
* [UltiSnips](https://github.com/sirver/UltiSnips) + Some of my own snippets
* Language Specific Plugins for languages and configuration for
  * PHP
  * Python
  * PgSQL
  * LaTeX
  * HTML, XHTML
  * Nix
* a lot of [tpope](https://github.com/tpope/)'s plugins
* Git integration is provided via [`vim-fugitive`](https://github.com/tpope/vim-fugitive) plugin.

## Interactive Shell Environment: tmux + zsh

This configuration includes a customized ZSH with powerline with a custom dark theme. It also contains integration with various tools.

### [direnv](https://github.com/direnv/direnv)

Allows you to set different environment variables and load different
configurations when entering a directory automatically if it contains a
`.envrc` configuration file. I use this in a lot of project root directories to
automatically spawn a [`nix-shell`]() when entering a directory which contains
all the development dependencies.

### [fzf](https://github.com/junegunn/fzf)

A general fuzzy search program. Is used in diverse places:

* Can be called from vim to fuzzy **s**earch **f**iles using `<Space>sf`
  while in normal mode
  * You can then press `CTRL-X` or `CTRL-V` to automatically open a new
    `:split` or `:vsplit` window respectively.
  * More vim keybindings can be found in my
    [vimrc](https://github.com/mogria/nixpkgs-config/blob/8ad8c3ac63112252327f23cdade00b421d05d4ec/vim/vimrc#L253).
    Feel free to adjust them to your needs.
* Can be called from zsh to fuzzy search files by typing `\<Tab>`
* Can be called from zsh to fuzzy search the shell history by pressing
  `CTRL-R`. This one is very useful and gets more useful the bigger your
  shell history is. (The size of the history `$HISTSIZE` is configured to be
    100000).

### [ripgrep](https://github.com/BurntSushi/ripgrep)

A fast recursive grep wit nice colored output. One of my most used shell
utilities during an interactive shell session. I even have a script
[`vrg`](https://github.com/mogria/nixpkgs-config/blob/master/bin/vrg) pass to
start vim and pass the search results into the quickfix list
automatically.

It can be called from within vim as well to fill the quickfix list using
`<Space>F` to search for the word below the cursor. `<Space>f` searches for the
last thing you searched using `/` in vim, so you can expand your file scoped
search to the while project directory. Alternatively type `:Rg` to search for
something else. This functionality is provided by the
[vim-ripgrep](https://github.com/jremmen/vim-ripgrep) plugin.

### Git Integration

Various tools have been configured to work better with git.

* **zsh**: Various aliases
 * https://github.com/mogria/nixpkgs-config/blob/8ad8c3ac63112252327f23cdade00b421d05d4ec/git/git.nix#L10-L28
* **vim**: Almost the same shortcuts prefixed with `<Space>` provided by the [`vim-fugitive`](https://github.com/tpope/vim-fugitive) plugin.
 * https://github.com/mogria/nixpkgs-config/blob/8ad8c3ac63112252327f23cdade00b421d05d4ec/vim/vimrc#L320-#L330
 * Vim is used as the difftool as well

### Graphical

Different graphical tools are included as well but only on Linux. This includes

* [Rofi](https://github.com/mogria/nixpkgs-config/blob/master/rofi/rofi.nix): A little menu I use to start programs and search for windows of currently opened windows. Only used on Linux in conjuction with the NixOS's XFCE 4.14a (needs to be activated in /etc/nixos/configuration.nix).
* [Alacritty terminal emulator](https://github.com/alacritty/alacritty): cross-platform GPU-accelerated terminal emulator

## Installation

* [Install Nix](https://nixos.org/nix/) or even [NixOS](https://nixos.org/nixos/)
* Clone this repository into `~/.config/nixpkgs`

      git clone https://github.com/mogria/nixpkgs-config.git ~/.config/nixpkgs

* Configure your git settings and github repositories in [`user-config.nix`](https://github.com/mogria/nixpkgs-config/blob/master/user-config.nix)
* Install Home-Manager: [https://github.com/rycee/home-manager](https://github.com/rycee/home-manager)
