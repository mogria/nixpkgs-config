{ config, pkgs, ... }:

let
  phpEnv = pkgs.php83.buildEnv {
      extensions = ({ enabled, all }: enabled ++ (with all; [
          xdebug
          ctype
          bcmath
          curl
          dom
          ds
          event
          exif
          fileinfo
          filter
          gd
          gettext
          iconv
          mbstring
          memcache
          mysqli
          openssl
          opcache
          pdo
          pdo_mysql
          pdo_pgsql
          pdo_sqlite
          pgsql
          posix
          protobuf
          readline
          redis
          session
          # simplexml
          sockets
          sqlite3
          # xml
          # xmlreader
          # xmlwriter
          # xsl
          yaml
          zip
          zlib

      ]));
      extraConfig = ''
          xdebug.mode=coverage
      '';
    };
in {

  home.packages = with pkgs.php83Packages; [
    phpEnv
    composer
    # phpmd
    # phpstan
    # psalm
    php-codesniffer
    ];
}

