{ pkgs ? import ./nix { } }:

let
  cargo_nix = pkgs.callPackage ./Cargo.nix { };
  actionstar = cargo_nix.rootCrate.build;

in { inherit actionstar; }
