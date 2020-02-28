{ pkgs ? import ./nix { } }:

let
  rustStable = pkgs.rustChannels.stable.rust;
  buildRustCrate = pkgs.buildRustCrate.override { rustc = rustStable; };
  cargo_nix = pkgs.callPackage ./Cargo.nix { inherit buildRustCrate; };
  actionstar = cargo_nix.rootCrate.build;

in { inherit actionstar; }
