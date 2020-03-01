{ sources ? import ./sources.nix, config ? { }, system ? builtins.currentSystem
, crossSystem ? null }:
with {
  moz_overlay = import sources.nixpkgs-mozilla;
  overlay = _: pkgs: {
    crate2nix = import sources.crate2nix { inherit pkgs; };
    lorri = import sources.lorri { inherit pkgs; };
    niv = import sources.niv { };
  };
};
import sources.nixpkgs {
  overlays = [ overlay moz_overlay ];
  inherit config system crossSystem;
}
