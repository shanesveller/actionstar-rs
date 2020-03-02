{ pkgs ? import ./nix { } }:

with pkgs;

mkShell {
  buildInputs = [ crate2nix direnv gnumake lorri openssl pkgconfig skopeo ]
    ++ (with pkgs.rustChannelOf { rustToolchain = ./rust-toolchain; };
      [ rust ]);
}
