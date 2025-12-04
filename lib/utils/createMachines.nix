{
  inputs,
  getPackages,
}: {machines}: let
  mkSystem = import ./../mkSystem.nix {
    inherit inputs getPackages;
    nixpkgs = inputs.nixpkgs;
  };
in
  inputs.nixpkgs.lib.mapAttrs (host: config: (
    mkSystem "${host}" config
  ))
  machines
