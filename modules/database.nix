{ pkgs, ... }: {
  home.packages = [
    pkgs.go-migrate
    pkgs.postgresql
    pkgs.sqlc
    pkgs.sqlite
    pkgs.sqlite-web
  ];
}
