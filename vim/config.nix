{ pkgs }:

let
  stdenv = pkgs.stdenv;
  smallIndent = { size = 2; useTabs = false; };
  fourIndent = { size = 4; useTabs = false; };
  cssConf = {
    indent = fourIndent;
    addKeywordChars = "-";
  };
  shellConf = {
    indent = fourIndent;
    makeCommands = [{
        filePattern = "*";
        makeprg = "shellcheck\\ --check-sourced\\ --external-sources\\ --format=gcc";
    }];
  };
  lispConf = {
    indent = smallIndent;
    addKeywordChars = "-";
    /** TODO: set showmatch
              set lisp
        NOTE: vim -l starts it in lisp mode**/
  };
  homeManagerMakePrg = "home-manager\\ switch;echo";
  languages = {
    "nix" = {
      indent = smallIndent;
      makeCommands = [
        { filePattern = "*/.config/nixpkgs/*"; makeprg = homeManagerMakePrg; }
        { filePattern = "/etc/nixos/*"; makeprg = "nixos-rebuild\\ switch;echo"; }
        { filePattern = "*"; makeprg = "nix\\ build"; }
      ];
      fileSearchPath = [ "/etc/nixos" "~/.config/nixpkgs" ];
    };
    "ruby" = {
      indent = smallIndent;
      makeCommands = [
        { filePattern = "*"; makeprg = "rubocop"; }
      ];
    };
    "python" = {
      indent = fourIndent;
      makeCommands = [
        { filePattern = "*"; makeprg = "pylint"; }
      ];
    };
    "yaml" = {
      indent = smallIndent;
    };
    "css" = cssConf;
    "scss" = cssConf;
    "markdown" = {
      indent = smallIndent;
      addKeywordChars = "-";
      makeCommands = [ { filePattern = "*"; makeprg = "~/bin/make-markdown"; } ];
    };
    "sh" = shellConf;
    "bash" = shellConf;
    "zsh" = shellConf;
    "vim" = {
      indent = smallIndent;
      makeCommands = [
        { filePattern = "*/.config/nixpkgs/vim/*"; makeprg = homeManagerMakePrg; }
      ];
    };
    "js" = {
      indent = fourIndent;
    };
    "tex" = {
      indent = fourIndent;
    };
    "lisp" = lispConf;
    "scheme" = lispConf // {
      makeCommands = [
        { filePattern = "*.rkt"; makeprg = "racket\\ -f\\ %"; }
      ];
    };
    "plantuml" = {
      indent = fourIndent;
      makeCommands = let
        makeprg = "plantuml";
      in [
        { filePattern = "*/uml/*.txt"; inherit makeprg; }
        { filePattern = "*.uml"; inherit makeprg; }
        { filePattern = "*.plantuml"; inherit makeprg; }
      ];
    };
  };

  getOrDefault = key: attrset: defaultValue:
    if builtins.hasAttr key attrset
      then builtins.getAttr key attrset
      else defaultValue;

  # general function which can generate
  # vim config for an option for all languages
  generateAllVimConfigLanguageOptions = option: vimConfigFunc:
    let generateLanguageOptions = lang: languageOptions:
      if builtins.hasAttr option languageOptions
        then vimConfigFunc lang (builtins.getAttr option languageOptions)
        else ""; # just generate an empty string if no option is set
    in builtins.concatStringsSep "\n" (stdenv.lib.mapAttrsToList generateLanguageOptions languages);

  indentVimConfig = let
      vimConfigFunc = lang: indentOption: let
        indent = toString (getOrDefault "size" indentOption 4); # default tab size
        tabsOption = getOrDefault "useTabs" indentOption false; # don't use tabs per default
        cIndent = if getOrDefault "cIndent" indentOption false # use smartindent as default
            then "cindent"
            else "smartindent";
      in ''
        autocmd FileType ${lang} set expandtab tabstop=${indent} softtabstop=${indent} shiftwidth=${indent} ${cIndent}
        ${if tabsOption then "autocmd FileType ${lang} set noexpandtab" else ""
        }'';
    in generateAllVimConfigLanguageOptions "indent" vimConfigFunc;

  makeCommandsVimConfig = let
      vimConfigFunc = lang: makeCommandsOption: let
        makeCommand = makeCommandOption: let
          pattern = getOrDefault "filePattern" makeCommandOption "*";
        in ''
          if a:currentfile =~ glob2regpat('${pattern}')
            setlocal makeprg=${makeCommandOption.makeprg}
            return
          endif
        '';
      in ''
        function! Filetype_${lang}_set_makeprg(currentfile)
        ${builtins.concatStringsSep "\n" (map makeCommand makeCommandsOption)}
        endfunction
        autocmd FileType ${lang} call Filetype_${lang}_set_makeprg(expand(expand("<afile>:p")))
      '';
    in generateAllVimConfigLanguageOptions "makeCommands" vimConfigFunc;

  addKeywordCharsVimConfig = let
      vimConfigFunc = lang: addKeywordCharsOption: ''autocmd FileType ${lang} set iskeyword+=${addKeywordCharsOption}'';
    in generateAllVimConfigLanguageOptions "addKeywordChars" vimConfigFunc;

  fileSearchPathVimConfig = let
      vimConfigFunc = lang: fileSearchPathOption:
        let path = builtins.concatStringsSep "," fileSearchPathOption;
        in ''autocmd FileType ${lang} set path+=${path}'';
    in generateAllVimConfigLanguageOptions "fileSearchPath" vimConfigFunc;



in ''
  " vim-plug: required for { do: commands } to install coc stuff} this
  " cannot be installed under the normal plugins either because they
  " get loaded after the vimrc...
  source ${pkgs.vimPlugins.vim-plug}/share/vim-plugins/vim-plug/plug.vim
  ${builtins.readFile ./vimrc}

  " nix generated, language specific file search path configurations
  ${fileSearchPathVimConfig}

  " nix generated, language specific makeprg configurationh
  ${makeCommandsVimConfig}

  " nix generated, language specific indentation configuration
  ${indentVimConfig}

  " nix generated, language specific keyword character definition
  ${addKeywordCharsVimConfig}
''
