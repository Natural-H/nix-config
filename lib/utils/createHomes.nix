{
  inputs,
  getPackages,
}: homes: let
  mkHome = import ./../mkHome.nix {
    inherit inputs getPackages;
  };
in
  inputs.nixpkgs.lib.mapAttrs (host: config: (
    mkHome config
  ))
  homes
