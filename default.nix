{ pkgs ? import <nixpkgs> { } }:

{
  inherit (pkgs) hello;
}
