{
  allowUnfree = true;

  # Install Nix User Repository (Nur)
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball {
      # Get the revision by choosing a version from https://github.com/nix-community/NUR/commits/master
      url = "https://github.com/nix-community/NUR/archive/cfd5ba1c70c471bbee7981df94299cb7db3bb7c6.tar.gz";
      # Get the hash by running `nix-prefetch-url --unpack <url>` on the above url
      sha256 = "0599yfdm3rm4hfx4jxxsxls9c5gfm38dgxmzdncqpw9irjkaqvbn";
    }) {
      inherit pkgs;
    };
  };
}
