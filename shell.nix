{ pkgs ? import ./nix { } }:

with pkgs;

mkShell {
  buildInputs = [ direnv lorri ]
    ++ (with pkgs.rustChannelOf { rustToolchain = ./rust-toolchain; };
      [ rust ]);
}
