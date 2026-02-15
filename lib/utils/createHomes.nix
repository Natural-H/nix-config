{
  inputs,
  getPackages,
}: homes: let
  mkHome = import ./../mkHome.nix {
    inherit inputs getPackages;
    nixpkgs = inputs.nixpkgs;
  };
in
  inputs.nixpkgs.lib.mapAttrs (host: config: (
    mkHome config
  ))
  homes
