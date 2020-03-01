{ system ? builtins.currentSystem, pkgs ? import ./nix { inherit system; } }:

let
  linuxPkgs = import ./nix { system = "x86_64-linux"; };
  # https://www.reddit.com/r/NixOS/comments/f0yi3b/how_to_build_a_simple_static_rust_binary_using/fh2asml/
  rust = (linuxPkgs.rustChannelOfTargets "stable" null
    [ "x86_64-unknown-linux-musl" ]);
  linuxBuildRustCrate = linuxPkgs.buildRustCrate.override { rustc = rust; };
  cargo_nix = linuxPkgs.callPackage ./Cargo.nix {
    buildRustCrate = linuxBuildRustCrate;
    pkgs = linuxPkgs;
  };
  actionstar = cargo_nix.rootCrate.build;
  dockerimage = linuxPkgs.dockerTools.buildLayeredImage {
    name = "actionstar";
    tag = "latest";
    contents = [ ];
    config = { Cmd = "${actionstar}/bin/actionstar"; };
  };

  unpackedImage = pkgs.runCommand "unpacked-image" { } ''
    ${pkgs.skopeo}/bin/skopeo --insecure-policy --override-os linux copy docker-archive:${dockerimage} dir:$out
  '';

  allImages = pkgs.linkFarm "images" [{
    name = "actionstar";
    path = unpackedImage;
  }];

in { inherit actionstar dockerimage unpackedImage allImages; }
