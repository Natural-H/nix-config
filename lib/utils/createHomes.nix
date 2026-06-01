{
  inputs,
  getPackages,
}: homes: let
  mkHome = import ./../mkHome.nix {
    inherit inputs getPackages;
    nixpkgs = inputs.nixpkgs-unstable;
  };
in
  inputs.nixpkgs.lib.mapAttrs (host: config: (
    mkHome config
  ))
  homes
