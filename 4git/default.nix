{ stdenv, bats, git, coreutils, bash, fd }:

stdenv.mkDerivation {
  pname = "4git";
  version = "0.1.1";
  src = ./.;

  propagatedBuildInputs = [
    git
    bash
    fd
  ];

  doCheck = true;

  checkInputs = [
    git
    bats
    coreutils
  ];

  buildPhase = ''
    patchShebangs bin
  '';

  checkPhase = ''
    # set git email and name, so no fatal errors
    # are thrown constantly
    export HOME=$TMPDIR
    git config --global user.email "nobody@example.com"
    git config --global user.name "Nobody"

    PATH="`pwd`/bin:$PATH" bats -r tests/
  '';

  installPhase = ''
    mkdir -p $out
    cp -r $src/bin $out/bin
  '';
}
