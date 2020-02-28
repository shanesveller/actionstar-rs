{ pkgs ? import ./nix { } }:

{
  inherit (pkgs) hello;
}
