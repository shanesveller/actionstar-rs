{ system ? builtins.currentSystem, crossSystem ? null, pkgs ? import ./nix {
  inherit system;
  crossSystem.config = crossSystem;
} }:

let
  cargo_nix = pkgs.callPackage ./Cargo.nix { };
  actionstar = cargo_nix.rootCrate.build;
  # linuxPackages = import (import ./nix/sources.nix {}).nixpkgs { crossSystem =  }
  rustLinux = pkgs.rustChannelOfTargets pkgs.latest.rustChannels.stable null
    [ "x86_64-unknown-linux-gnu" ];
  # linuxBuildCrate = pkgs.buildRustCrate.override { inherit (rustLinux) rustc; };
  # actionstarLinux = (pkgs.callPackage ./Cargo.nix {
  #   buildRustCrate = linuxBuildCrate;
  # }).rootCrate.build;
  dockerimage = pkgs.dockerTools.buildLayeredImage {
    name = "actionstar";
    tag = "latest";
    # created = "now";
    contents = [ actionstar ];
    config = { Cmd = "${actionstar}/bin/actionstar"; };
  };

in { inherit actionstar dockerimage; }
