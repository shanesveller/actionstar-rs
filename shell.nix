{ pkgs ? import ./nix { } }:

with pkgs;

mkShell {
  buildInputs = [ direnv lorri skopeo ]
    ++ (with pkgs.rustChannelOf { rustToolchain = ./rust-toolchain; };
      [ rust ]);
}
