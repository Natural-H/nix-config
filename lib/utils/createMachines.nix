{
  inputs,
  getPackages,
}: machines: let
  mkSystem = import ./../mkSystem.nix {
    inherit inputs getPackages;
  };
in
  inputs.nixpkgs.lib.mapAttrs (host: config: (
    mkSystem "${host}" config
  ))
  machines
