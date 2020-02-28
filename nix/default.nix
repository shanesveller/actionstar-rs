{ sources ? import ./sources.nix }:
with {
  moz_overlay = import sources.nixpkgs-mozilla;
  overlay = _: pkgs: {
    lorri = import sources.lorri { inherit pkgs; };
    niv = import sources.niv { };
  };
};
import sources.nixpkgs {
  overlays = [ overlay moz_overlay ];
  config = { };
}
