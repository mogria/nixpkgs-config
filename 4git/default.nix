{ stdenv, bats }:

stdenv.mkDerivation {
  pname = "4git";
  version = "0.1.0";
  src = ./.;

  nativeBuildInputs = [
    bats
  ];

  # doCheck = true;
  #
  # checkPhase = ''
  #   bats -r tests/
  # '';

  installPhase = ''
    mkdir -p $out/bin
    cp $src/src/4git-* $out/bin
    cp $src/src/*.sh $out/bin
  '';
}
