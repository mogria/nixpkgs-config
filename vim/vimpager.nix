{ pkgs, ...}:

let
  # no asci esc here
  vimpager-fast = { stdenv, lib, makeWrapper, vimpager-latest }:
    stdenv.mkDerivation {
      pname = "vimpager-fast";
      version = "0.0.1";
  
      dontUnpack = true;
      buildInputs = [ makeWrapper ];
  
      installPhase = ''
        mkdir -p $out/bin
        cp -aR ${vimpager-latest.out}/bin/* $out/bin

        for f in $out/bin/*; do
          [ ! -f "$f" ] && continue
          [ ! -x "$f" ] && continue
          wrapProgram "$f" \
            --add-flags -c \
            --add-flags "'set ft=&ft'"
        done
      '';

      meta = {
        description = "Vimpager which starts without ansiesc";
        homepage = https://github.com/rkitover/vimpager;
        license = lib.licenses.mit;
        maintainers = lib.maintainers.mogria;
        platforms = vimpager-latest.meta.platforms;
      };
    };
in {
  home.packages = with pkgs; [
    (callPackage vimpager-fast {})
  ];

  home.sessionVariables = {
    "PAGER" = "vimpager -u ~/.vimpagerrc";
    "VIMPAGER_RC" = "\$HOME/.vimpagerrc";
    "VIMPAGER_VIM" = "vim";
  };

  home.file.".vimpagerrc".text = ''
    syntax on

    set incsearch
    set ignorecase
    " searches with only small latters are case-insensitive
    set smartcase
    " start search again
    set wrapscan

    " easier quitting
    noremap q <Esc>ZQ
    noremap Q <Esc>:q!<CR>

    map Y "+y
    noremap YY ggvG$"+y<C-O><C-O>

    nmap <Space> v

    " OLD VIMPAGER CONFIGURATION {{{
    " let g:vimpager = {}
    let g:vimpager.ansiesc = 0
    " let g:less = {}
    " Plugin 'rkitover/vimpager'
    " }}}

  '';
}
