{ system ? builtins.currentSystem, pkgs ? import ./nix { inherit system; } }:

let
  # https://www.reddit.com/r/NixOS/comments/f0yi3b/how_to_build_a_simple_static_rust_binary_using/fh2asml/
  rust = (pkgs.rustChannelOf { channel = "stable"; }).rust.override {
    # extensions = [ "rust-src" ];
    targets = [ "x86_64-unknown-linux-musl" ];
  };
  linuxBuildRustCrate = pkgs.buildRustCrate.override { rustc = rust; };
  cargo_nix = pkgs.callPackage ./Cargo.nix {
    inherit pkgs;
    buildRustCrate = linuxBuildRustCrate;
  };
  actionstar = cargo_nix.rootCrate.build;
  dockerimage = pkgs.dockerTools.buildLayeredImage {
    name = "actionstar";
    tag = "latest";
    # created = "now";
    contents = [ ];
    config = { Cmd = "${actionstar}/bin/actionstar"; };
  };

in { inherit actionstar dockerimage; }
