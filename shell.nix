{ pkgs ? import ./nix { } }:

with pkgs;

mkShell { buildInputs = [ direnv lorri ]; }
