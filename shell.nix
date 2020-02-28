{ pkgs ? import ./nix { } }:

with pkgs;

mkShell {
  buildInputs = [ crate2nix direnv lorri skopeo ]
    ++ (with pkgs.rustChannelOf { rustToolchain = ./rust-toolchain; };
      [ rust ]);
}
