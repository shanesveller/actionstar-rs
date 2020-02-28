{ sources ? import ./sources.nix }:
with {
  overlay = _: pkgs: {
    lorri = import sources.lorri { inherit pkgs; };
    niv = import sources.niv { };
  };
};
import sources.nixpkgs {
  overlays = [ overlay ];
  config = { };
}
