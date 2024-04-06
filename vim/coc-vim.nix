{ pkgs, lib, ... }:

{

  imports = [
  	../php.nix
  ];

  home.packages = with pkgs; [
      ## Nix Language Support
      rnix-lsp
      nixpkgs-fmt # ale fixer (nixfmt exists as well)

      ## Rust Language Support
      rustup
      # rls
      # rustc
      # cargo
      # These are not required as they are provide by rustup

      ## Bash Language Support
      shellcheck # linter for shell scripts
      shfmt # ale fixer for shell scripts
      bats # tests for bash
    ] ++ (with python3Packages; [
      ## Python Language Support
      sqlparse # ALE lint sql code (postgresql)
      pylint # ALE lint python code
      # python-language-server # coc-python # MacOS: errors in tests
    
    ]);

  xdg.configFile."nvim/coc-settings.json".text = ''
  {
    "suggest.enablePreview":  true,
    "diagnostic.displayByAle": true,
    "codeLens.enable": true,
    "languageserver": {
      "psalmls": {
        "command": "vendor/bin/psalm-language-server",
        "args": ["--find-dead-code", "--disable-on-change=100000", "--use-extended-diagnostic-codes", "--verbose"],
        "filetypes": ["php"],
        "rootPatterns": ["psalm.xml", "psalm.xml.dist"],
        "requireRootPattern": true,
        "trace.server": "verbose"
      },
      "nix": {
        "command": "rnix-lsp",
        "filetypes": ["nix"]
      },
    },
  }
  '';

  programs.neovim.plugins = with pkgs.vimPlugins; [ 
      coc-nvim
      coc-vimtex
      # Note: this requires the command :CocCommand python.setInterpreter pythonXX to work
      coc-python 
      coc-css
      coc-html
      coc-java
      coc-yaml
      coc-json
      coc-neco
      # coc-fzf
      coc-git
      coc-yank
      coc-rust-analyzer
      coc-snippets
      coc-pairs
      coc-neco
      coc-spell-checker
      coc-highlight
  ];
}
