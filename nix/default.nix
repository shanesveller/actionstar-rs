{ sources ? import ./sources.nix, config ? { }, system ? builtins.currentSystem
, crossSystem ? null }:
with {
  moz_overlay = import sources.nixpkgs-mozilla;
  overlay = _: pkgs: {
    crate2nix = import sources.crate2nix { inherit pkgs; };
    lorri = import sources.lorri { inherit pkgs; };
    niv = import sources.niv { };
    inherit (import sources.unstable { inherit system; }) skopeo;
  };
};
import sources.nixpkgs {
  overlays = [ overlay moz_overlay ];
  inherit config system crossSystem;
}
