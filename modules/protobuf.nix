{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    protobuf # protoc
  ];
}

