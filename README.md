# dotfiles

These are my [Nix](https://nixos.org/nix/) and
[Home-Manager](https://github.com/rycee/home-manager/) based configuration for my home directory
files.

These configuration files are in use on 64-bit Linux NixOS machine and on a
MacOS machine.  Some minor modifications might be needed to make them
runnable on Linux on aarch64 or with other distributions than NixOS just
using the Nix package manager.

# Tools Included

## Programming: NeoVim

These configuration files contain a heavily customized neovim with a lot of plugins for supporting programming. I usallaly start multiple instances of neovim. I do this from within the Alacritty terminal emulator which from within a `tmux` session is launched automatically.

Some of these include:

* Synastic
* UltiSnips + Some of my own snippets
* Language Specific Plugins for languages such as
  * PHP
  * HTML
  * Nix
* a lot of tpope's plugins
* Git integration is provided via fugitive

## Interactive: tmux + zsh

This configuration includes a customized ZSH with powerline with a custom dark theme. It also contains integration with various tools such as

* [direnv](): Set different Environment variables and load different
   configurations when entering a directory automatically if it contains
   a .envrc configuration file. I use this in a lot of project's to
   automatically spawn a [`nix-shell`]() when entering a directory which
   contains all the development dependencies.
* [fzf](): fuzzy search for files directory and also your shell history.

## Graphical

Different graphical tools are included as well. This includes

* [Rofi](https://github.com/mogria/nixpkgs-config/blob/master/rofi/rofi.nix): A little menu I use to start programs and search for windows of currently opened windows. Only used on Linux in conjuction with the NixOS's XFCE 4.14a (needs to be activated in /etc/nixos/configuration.nix).

# Installation

* Install Nix
* Clone this repository into `~/.config/nixpkgs`

      git clone https://github.com/mogria/nixpkgs-config.git ~/.config/nixpkgs

* Install Home-Manager: [https://github.com/rycee/home-manager](https://github.com/rycee/home-manager)
