{ pkgs, ... }:
let
  go-migrate-mysql = pkgs.go-migrate.overrideAttrs (oldAttrs: {
    tags = [ "mysql" ];
  });
in
{

  home.packages = with pkgs; [
    go-migrate-mysql
    # go-migrate
    postgresql
    sqlc
    sqlite
    sqlite-web
  ];
}
