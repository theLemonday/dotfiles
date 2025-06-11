{ pkgs, ... }:
let
  go-migrate-mysql = pkgs.go-migrate.overrideAttrs (oldAttrs: {
    tags = [ "mysql" ];
  });
in
{

  home.packages = [
    go-migrate-mysql
    # pkgs.go-migrate
    pkgs.postgresql
    pkgs.sqlc
    pkgs.sqlite
    pkgs.sqlite-web
  ];
}
