{
  allowUnfree = true;

  # Install Nix User Repository (Nur)
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball {
      # Get the revision by choosing a version from https://github.com/nix-community/NUR/commits/master
      url = "https://github.com/nix-community/NUR/archive/b353e4ce5723c24baf13b5c71d4b32901cd9ad7c.tar.gz";
      # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
      sha256 = "1yhq3zn1wz96c344p372086i8q97z5hd0wb07p44qblw7j7s3093";
    }) {
      inherit pkgs;
    };
  };
}
