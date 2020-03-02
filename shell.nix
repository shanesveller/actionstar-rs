{ pkgs ? import ./nix { } }:

with pkgs;

mkShell {
  buildInputs = [ crate2nix darwin.apple_sdk.frameworks.Security direnv gnumake lorri openssl pkgconfig skopeo ]
    ++ (with pkgs.rustChannelOf { rustToolchain = ./rust-toolchain; };
      [ rust ]);
}
