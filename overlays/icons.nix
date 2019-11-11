self: super: {
  faience-ng-icon-theme = super.stdenv.mkDerivation rec {
    name = "${pname}-${version}";
    pname = "faience-ng-icon-theme";
    version = "v${releasedate}";
    releasedate = "20180126";
    src =  self.pkgs.fetchurl {
      url = "https://github.com/faience/${pname}/releases/download/${version}/${pname}-${releasedate}.tar.gz";
      sha256 = "0szpzclsanfjqqaza45am4qfykfprxz4fs5q8hw159xflk91fqv4";
    };
    sourceRoot = ".";
    postUnpack = ''
      mkdir theme
      mv Faience* theme/
    '';
    installPhase = ''
      mkdir -p $out/share/icons
    '';
  };

  griffin-ghost-icon-theme= super.stdenv.mkDerivation rec {
    name = "${pname}-${version}";
    pname = "griffin-ghost-icon-theme";
    version = "v${releasedate}";
    releasedate = "20180126";
    src =  self.pkgs.fetchFromGitHub {
      owner = "LordShenron";
      repo = "Griffin-Icons";
      rev = "4edbd4cb24eb28d38b3c458ff07f6aba2b6c2712";
      sha256 = "05i37bv3fw3dsw9323cq4pnbrd03p364f67iif2yg775n3ixrzzg";
    };
    installPhase = ''
      mkdir -p $out/share/icons/Griffin-Ghost
      cp -R ./* $out/share/icons/Griffin-Ghost
    '';
  };
}
