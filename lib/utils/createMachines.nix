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
    mkSystem "${host}" {
      inherit (config) system users;
      wsl = config.wsl or false;
      enableNixLd = config.enableNixLd or false;
    }
  ))
  machines
