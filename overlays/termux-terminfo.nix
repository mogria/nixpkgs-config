self: super: {

  # this termfile allows tmux to display underlined
  # and strike-through text correctly.
  # see https://github.com/tmux/tmux/issues/1137
  # (only works for italics but has problems with using backspace)
  tmux-256colors-terminfo = super.stdenv.mkDerivation {
    name = "tmux-256colors-terminfo-fixed";
    verions = "0.0.1";
    src = ./../tmux/tmux-256color.info;
    outputs = [ "out" "terminfo" ];
    unpackPhase = ''
      cp $src .
    '';
    buildPhase = ''mkdir $out'';
    installPhase = ''
      install -dm 755 "$terminfo/share/terminfo/t/"
      ${self.pkgs.ncurses}/bin/tic -x -o "$terminfo/share/terminfo" $src
      mkdir -p $out/nix-support
      echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
    '';
  };
}
