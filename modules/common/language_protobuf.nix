{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    protobuf # protoc
    buf
    grpcurl
    protoc-gen-go
  ];
}

