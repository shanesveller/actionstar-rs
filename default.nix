{ system ? builtins.currentSystem, pkgs ? import ./nix { inherit system; } }:

let
  # https://www.reddit.com/r/NixOS/comments/f0yi3b/how_to_build_a_simple_static_rust_binary_using/fh2asml/
  rust =
    (pkgs.rustChannelOfTargets "stable" null [ "x86_64-unknown-linux-musl" ]);
  linuxBuildRustCrate = pkgs.buildRustCrate.override { rustc = rust; };
  cargo_nix = pkgs.callPackage ./Cargo.nix {
    inherit pkgs;
    buildRustCrate = linuxBuildRustCrate;
  };
  actionstar = cargo_nix.rootCrate.build;
  dockerimage = pkgs.dockerTools.buildLayeredImage {
    name = "actionstar";
    tag = "latest";
    contents = [ ];
    config = { Cmd = "${actionstar}/bin/actionstar"; };
  };

in { inherit actionstar dockerimage; }
